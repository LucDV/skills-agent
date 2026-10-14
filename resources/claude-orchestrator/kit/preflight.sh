#!/bin/bash
# Dùng: preflight.sh [--pull] [--deps] [--update-tools] [--baseline]
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; source "$DIR/detect.sh"
ok(){ echo "✅ $*"; }; warn(){ echo "⚠️  $*"; }; fail(){ echo "❌ $*"; FAILED=1; }
FAILED=0; ARGS=" $* "; cd "$ROOT"; mkdir -p .orchestrator

command -v git >/dev/null && ok "git" || fail "thiếu git"

# Kiểm tra từng worker khai báo trong .orchestrator.env
[ -z "${WORKERS:-}" ] && fail "chưa khai báo WORKERS trong .orchestrator.env"
for W in ${WORKERS:-}; do
  K=$(echo "$W" | tr 'a-z-' 'A-Z_'); V="WORKER_${K}_CMD"; C="${!V:-}"
  BIN=$(echo "$C" | awk '{print $1}')
  if   [ -z "$C" ]; then warn "worker $W: thiếu $V"
  elif command -v "$BIN" >/dev/null; then ok "worker $W ($BIN)"
  elif [ "$W" = "${DEFAULT_WORKER:-}" ]; then fail "worker mặc định $W: chưa cài '$BIN'"
  else warn "worker $W: chưa cài '$BIN'"; fi
  if [[ $ARGS == *" --update-tools "* ]]; then
    U="WORKER_${K}_UPDATE"; [ -n "${!U:-}" ] && { eval "${!U}" 2>&1 | tail -2 || true; }
  fi
done

[ -n "$(git status --porcelain)" ] && warn "working tree chưa sạch (worktree mới chỉ lấy phần đã commit)" || ok "working tree sạch"

if git fetch -q 2>/dev/null; then
  BEHIND=$(git rev-list --count "HEAD..@{u}" 2>/dev/null || echo 0)
  if [ "$BEHIND" -gt 0 ]; then
    if [[ $ARGS == *" --pull "* ]]; then
      git pull --ff-only -q && ok "đã pull $BEHIND commit" || fail "pull lỗi"
    else warn "đang sau remote $BEHIND commit (thêm --pull để cập nhật)"; fi
  else ok "đã cập nhật so với remote"; fi
fi

if [[ $ARGS == *" --deps "* ]]; then
  if [ -n "${SETUP_CMD:-}" ]; then
    if (eval "$SETUP_CMD") > .orchestrator/setup.log 2>&1; then ok "setup: $SETUP_CMD"
    else fail "setup lỗi"; tail -15 .orchestrator/setup.log; fi
  else warn "chưa có SETUP_CMD (chạy /orchestrator-init)"; fi
fi

if [ -z "${TEST_CMD:-}" ]; then warn "chưa có TEST_CMD, hãy chạy /orchestrator-init"
elif [[ $ARGS == *" --baseline "* ]]; then
  if (eval "$TEST_CMD") > .orchestrator/baseline.log 2>&1; then ok "baseline test pass"
  else fail "baseline test đang FAIL"; tail -20 .orchestrator/baseline.log; fi
fi
exit $FAILED
