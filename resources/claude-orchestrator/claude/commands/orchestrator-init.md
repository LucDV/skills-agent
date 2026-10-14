---
description: Đọc project, quyết định lệnh setup/lint/build/test và ghi vào .orchestrator.conf
---
Mục tiêu: tạo `.orchestrator.conf` chính xác cho project này. Chỉ làm một lần (hoặc khi stack thay đổi).

## Cách làm
1. Chạy `.orchestrator-kit/init-project.sh` nếu chưa có thư mục tasks/.
2. Đọc có chọn lọc, KHÔNG đọc toàn bộ source:
   - README, CONTRIBUTING
   - File khai báo: package.json, pubspec.yaml, build.gradle*, settings.gradle*, Package.swift,
     *.xcodeproj / *.xcworkspace, Podfile, Fastfile, Cargo.toml, go.mod, pyproject.toml, Makefile, justfile
   - CI: .github/workflows, .gitlab-ci.yml, bitrise.yml. Đây là nguồn đáng tin nhất về lệnh
     mà team thực sự chạy.
3. Quyết định các biến sau (để trống nếu project không có):
   - SETUP_CMD: cài dependency (không nâng cấp phiên bản)
   - LINT_CMD: lint / analyze / format check
   - BUILD_CMD: kiểm tra compile nhanh nhất có thể
   - TEST_CMD: unit test. Ưu tiên loại chạy nhanh, không cần simulator, thiết bị hay secret.
   - BASE_BRANCH: nhánh chính (nếu không phải nhánh hiện tại)
4. Chạy thử từng lệnh (SETUP, LINT, BUILD, TEST) để xác nhận chạy được. Nếu lệnh quá nặng hoặc cần
   simulator/secret/mạng bên ngoài, đừng đoán: ghi vào báo cáo và hỏi tôi.
5. Ghi `.orchestrator.conf` (bash, mỗi biến một dòng). Trên mỗi biến có một dòng comment ghi nguồn,
   ví dụ `# từ .github/workflows/ci.yml`. Monorepo: chọn lệnh phạm vi hẹp nhất có thể, nối bằng `&&`.
6. Báo cáo ngắn: mỗi lệnh, nguồn, đã chạy thử pass/fail. Hỏi tôi xác nhận. KHÔNG commit khi chưa được xác nhận.

## Giới hạn
- Không sửa code project, không cài công cụ toàn cục, không chạy lệnh deploy/publish/push.
- Không đụng vào `.orchestrator.env` hay `.orchestrator.env.local` (đó là cấu hình worker của tôi).
