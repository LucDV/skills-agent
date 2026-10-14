#!/bin/bash
# Dùng: delegate.sh <task-file> [worker]
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; source "$DIR/detect.sh"
TASK="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"; NAME=$(basename "$TASK" .md)
WT="$ROOT/../.wt-$(basename "$ROOT")-$NAME"
OUT="$ROOT/.orchestrator"; mkdir -p "$OUT"
LOG="$OUT/$NAME.log"; PROMPT="$OUT/$NAME.prompt.md"

# Đọc dòng "Worker:" / "Model:" ở đầu task file (nếu có)
hdr(){ grep -m1 -i "^$1:" "$TASK" | sed 's/^[^:]*:[[:space:]]*//' || true; }

# Chọn worker: tham số > dòng Worker: trong task > DEFAULT_WORKER
WORKER="${2:-$(hdr Worker)}"; WORKER="${WORKER:-${DEFAULT_WORKER:-}}"
[ -n "$WORKER" ] || { echo "Chưa chọn worker (đặt DEFAULT_WORKER trong .orchestrator.env)"; exit 1; }
case " ${WORKERS:-} " in
  *" $WORKER "*) ;;
  *) echo "Worker '$WORKER' không nằm trong WORKERS: ${WORKERS:-<trống>}"; exit 1;;
esac

KEY=$(echo "$WORKER" | tr 'a-z-' 'A-Z_')
CMD_VAR="WORKER_${KEY}_CMD"; MODEL_VAR="WORKER_${KEY}_MODEL"
CMD="${!CMD_VAR:-}"; [ -n "$CMD" ] || { echo "Thiếu $CMD_VAR trong .orchestrator.env"; exit 1; }
MODEL="$(hdr Model)"; MODEL="${MODEL:-${!MODEL_VAR:-}}"

if [ -z "${SKIP_PREFLIGHT:-}" ]; then
  "$DIR/preflight.sh" || { echo "Preflight lỗi, dừng."; exit 1; }
fi

# Worktree riêng; cài dependency trong worktree vì nó chỉ chứa file đã commit
if [ ! -d "$WT" ]; then
  git -C "$ROOT" worktree add "$WT" -b "task/$NAME" "$BASE_BRANCH"
  if [ -n "${SETUP_CMD:-}" ]; then
    (cd "$WT" && eval "$SETUP_CMD") > "$OUT/$NAME.setup.log" 2>&1 \
      || echo "⚠️ setup trong worktree lỗi, xem .orchestrator/$NAME.setup.log"
  fi
fi

# Prompt = nội dung task + quy tắc
{ cat "$TASK"; printf '\n\nQuy tắc: bạn là worker, tự code trực tiếp, KHÔNG dùng /orchestrate và không giao việc cho worker khác. Chỉ sửa file trong mục "File được phép sửa". Chạy lệnh trong mục "Lệnh kiểm tra" trước khi kết thúc. Tóm tắt tối đa 5 dòng.\n'; } > "$PROMPT"

CMD="${CMD//@PROMPT_FILE@/$PROMPT}"
CMD="${CMD//@MODEL@/$MODEL}"

echo "Worker: $WORKER${MODEL:+ (model: $MODEL)}"
(cd "$WT" && eval "$CMD") > "$LOG" 2>&1 || true

cd "$WT"
git add -A
git commit -qm "task $NAME (worker: $WORKER)" || echo "Worker không tạo thay đổi nào"
echo "Branch: task/$NAME"; tail -10 "$LOG"
