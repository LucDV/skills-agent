#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; source "$DIR/detect.sh"
cd "$ROOT"; mkdir -p tasks .orchestrator
for p in ".orchestrator/" ".orchestrator.env.local"; do
  grep -qxF "$p" .gitignore 2>/dev/null || echo "$p" >> .gitignore
done
[ -f .orchestrator.env ] || cp "$DIR/orchestrator.env.example" .orchestrator.env
[ -f .orchestrator.conf ] || cat > .orchestrator.conf <<'CONF'
# Lệnh của project. Do /orchestrator-init điền, bạn có thể sửa tay.
# SETUP_CMD=""    # cài dependency
# LINT_CMD=""
# BUILD_CMD=""    # kiểm tra compile nhanh
# TEST_CMD=""
# BASE_BRANCH=""
CONF
[ -f tasks/_TEMPLATE.md ] || cat > tasks/_TEMPLATE.md <<'TPL'
Worker:
Model:
# Mục tiêu

## File được phép sửa
- path/to/file
- path/to/folder/

## Tham khảo
- file mẫu để worker làm theo

## Tiêu chí hoàn thành
-

## Lệnh kiểm tra
TPL
echo "Đã khởi tạo. Chạy /orchestrator-init trong Claude Code để điền .orchestrator.conf"
