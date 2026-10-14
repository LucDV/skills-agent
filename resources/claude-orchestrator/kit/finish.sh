#!/bin/bash
# Dùng: finish.sh <tên-task>   → merge nhánh task vào nhánh hiện tại, dọn worktree
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; source "$DIR/detect.sh"
NAME=$1; WT="$ROOT/../.wt-$(basename "$ROOT")-$NAME"
cd "$ROOT"
git merge --no-ff "task/$NAME" -m "Merge task/$NAME"
git worktree remove "$WT" --force
git branch -d "task/$NAME"
echo "Đã merge và dọn task $NAME"
