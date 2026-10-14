#!/bin/bash
# Dùng: ./install.sh [đường-dẫn-project]   (mặc định: thư mục hiện tại)
# Chạy lại để cập nhật kit; không ghi đè .orchestrator.conf / .orchestrator.env / tasks/.
set -e
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="$(cd "${1:-.}" && pwd)"
git -C "$TARGET" rev-parse --show-toplevel >/dev/null 2>&1 \
  || { echo "$TARGET không phải git repo"; exit 1; }

mkdir -p "$TARGET/.orchestrator-kit" "$TARGET/.claude/commands"
cp "$SRC"/kit/* "$TARGET/.orchestrator-kit/"
cp "$SRC"/claude/commands/*.md "$TARGET/.claude/commands/"
chmod +x "$TARGET"/.orchestrator-kit/*.sh

touch "$TARGET/CLAUDE.md"
grep -q "ORCHESTRATOR-RULES" "$TARGET/CLAUDE.md" || {
  echo >> "$TARGET/CLAUDE.md"
  cat "$SRC/claude/CLAUDE.snippet.md" >> "$TARGET/CLAUDE.md"
}

(cd "$TARGET" && .orchestrator-kit/init-project.sh)
echo "Xong. Mở Claude Code trong $TARGET, chạy /orchestrator-init rồi /orchestrate"
