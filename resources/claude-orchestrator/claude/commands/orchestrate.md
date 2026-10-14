---
description: Chia task, giao worker làm, verify và merge
---
Yêu cầu: $ARGUMENTS

1. Nếu chưa có thư mục tasks/, chạy `.orchestrator-kit/init-project.sh`.
   Nếu `.orchestrator.conf` chưa có TEST_CMD (các dòng còn đang là comment), dừng lại và làm theo
   hướng dẫn của /orchestrator-init trước khi tiếp tục.
2. Chạy `.orchestrator-kit/preflight.sh --pull --deps --baseline`. Nếu lỗi thì dừng và báo.
3. Chia yêu cầu thành các task nhỏ, độc lập, ghi vào tasks/NNN-ten.md theo tasks/_TEMPLATE.md.
   Đọc `.orchestrator.env` (danh sách WORKERS và các dòng _HINT) để chọn worker cho từng task.
   Ưu tiên worker rẻ nhất mà đủ sức làm task, ghi vào đầu task file: `Worker: <tên>` (và `Model:` nếu cần).
4. Giao từng task: `.orchestrator-kit/delegate.sh tasks/NNN-ten.md`.
   Các task không đụng chung file có thể chạy song song (đặt SKIP_PREFLIGHT=1 sau lần đầu).
5. Kiểm tra: `.orchestrator-kit/verify.sh NNN-ten`. Chỉ đọc output này, rồi đọc diff của đúng file có vấn đề.
6. Đạt: `.orchestrator-kit/finish.sh NNN-ten`. Không đạt: ghi lỗi vào task file và giao lại (tối đa 2 lần),
   sau đó tự sửa.
7. Báo cáo ngắn: task nào xong, task nào tự xử lý, test cuối cùng ra sao.
