<!-- ORCHESTRATOR-RULES -->
## Điều phối task (khi dùng /orchestrate)
- Với task lớn: không tự code, chia nhỏ và giao cho worker qua script ở .orchestrator-kit/.
- Chỉ dùng worker khai báo trong .orchestrator.env. Luôn chạy preflight trước khi bắt đầu, verify trước khi merge.
- Tiết kiệm token: chỉ đọc output của verify.sh, không đọc log đầy đủ hay toàn bộ diff.
- Tự làm: việc <10 dòng, auth, thanh toán, migration, quyết định kiến trúc.
- Tối đa 2 lần giao lại một task, sau đó tự sửa.
