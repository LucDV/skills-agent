#!/bin/bash
# Dùng: verify.sh <tên-task>   (tên file task, không có .md)
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; source "$DIR/detect.sh"
NAME=$1; TASK="$ROOT/tasks/$NAME.md"
WT="$ROOT/../.wt-$(basename "$ROOT")-$NAME"
[ -d "$WT" ] || { echo "Không thấy worktree của task $NAME"; exit 1; }
cd "$WT"

echo "== FILES =="; git diff "$BASE_BRANCH"...HEAD --stat | tail -15

echo "== SCOPE =="
ALLOWED=$(awk '/^## File được phép sửa/{f=1;next} /^## /{f=0} f&&/^- /{sub(/^- /,"");print}' "$TASK")
if [ -z "$ALLOWED" ]; then echo "(task không khai báo 'File được phép sửa')"; fi
for f in $(git diff "$BASE_BRANCH"...HEAD --name-only); do
  hit=0
  while read -r a; do
    [ -z "$a" ] && continue
    case "$a" in */) [[ "$f" == "$a"* ]] && hit=1;; *) [ "$f" = "$a" ] && hit=1;; esac
  done <<< "$ALLOWED"
  [ $hit = 1 ] || echo "NGOÀI PHẠM VI: $f"
done

[ -n "${LINT_CMD:-}" ]  && { echo "== LINT ==";  eval "$LINT_CMD"  2>&1 | tail -30; }
[ -n "${BUILD_CMD:-}" ] && { echo "== BUILD =="; eval "$BUILD_CMD" 2>&1 | tail -30; }
[ -n "${TEST_CMD:-}" ]  && { echo "== TEST ==";  eval "$TEST_CMD"  2>&1 | tail -40; }
# Lệnh kiểm tra hẹp do agent viết trong task (mục "Lệnh kiểm tra")
TASK_CMD=$(awk '/^## Lệnh kiểm tra/{f=1;next} /^## /{f=0} f&&NF&&!/^#/' "$TASK")
[ -n "$TASK_CMD" ] && { echo "== TASK CHECK =="; eval "$TASK_CMD" 2>&1 | tail -40; }
true
