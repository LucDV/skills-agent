# claude-orchestrator

Bộ công cụ để **Claude Code làm người điều phối**: chia task nhỏ, giao cho worker khác (Cursor CLI, Aider + Ollama, Claude Haiku...),
sau đó verify bằng script và merge. Mục tiêu: Claude chỉ đọc kết quả verify rút gọn thay vì tự viết hết code, nên tiết kiệm token.

## Cài vào một project

```bash
git clone --depth 1 git@github.com:<ten-ban>/claude-orchestrator.git /tmp/co \
  && /tmp/co/install.sh . && rm -rf /tmp/co
```

Chạy lại lệnh trên để cập nhật kit. Installer không ghi đè `.orchestrator.conf`, `.orchestrator.env` và `tasks/`.

Hoặc copy tay: `kit/` → `<project>/.orchestrator-kit/`, `claude/commands/*.md` → `<project>/.claude/commands/`,
nối `claude/CLAUDE.snippet.md` vào `<project>/CLAUDE.md`, rồi chạy `.orchestrator-kit/init-project.sh`.

## Dùng

Trong Claude Code, mở project:

1. `/orchestrator-init`: agent đọc README/manifest/CI, điền `.orchestrator.conf`, chạy thử và hỏi bạn xác nhận (làm một lần).
2. Sửa `.orchestrator.env`: giữ lại các worker bạn dùng, chỉnh `_CMD` theo `--help` của công cụ.
3. `/preflight`: kiểm tra worker, git, cập nhật, dependency, baseline test.
4. `/orchestrate <yêu cầu>`: chia task, chọn worker, giao, verify, merge.

## Các file cấu hình trong project

| File | Nội dung | Commit |
|---|---|---|
| `.orchestrator.conf` | Lệnh project: SETUP_CMD, LINT_CMD, BUILD_CMD, TEST_CMD, BASE_BRANCH | Có |
| `.orchestrator.env` | Danh sách worker, model, mẫu lệnh, gợi ý khi nào dùng | Có (không secret) |
| `.orchestrator.env.local` | API key, ghi đè cá nhân | Không |
| `tasks/NNN-ten.md` | Task do agent viết (dòng `Worker:` / `Model:` tùy chọn) | Tùy bạn |

## Cờ của preflight

| Cờ | Tác dụng |
|---|---|
| (mặc định) | Kiểm tra git, từng worker, working tree, remote |
| `--pull` | `git pull --ff-only` nếu tụt sau remote |
| `--deps` | Chạy `SETUP_CMD` |
| `--update-tools` | Chạy `WORKER_<TÊN>_UPDATE` của từng worker |
| `--baseline` | Chạy `TEST_CMD` trước khi bắt đầu |

## Thêm một worker

Trong `.orchestrator.env`, thêm tên vào `WORKERS` và khai báo:

```bash
WORKER_MYTOOL_CMD='mytool --prompt-file "@PROMPT_FILE@" --model @MODEL@'
WORKER_MYTOOL_MODEL="model-name"
WORKER_MYTOOL_HINT="Khi nào nên dùng worker này"
```

Tên `my-tool` trong `WORKERS` tương ứng biến `WORKER_MY_TOOL_*`.

## Lưu ý

- `.orchestrator.conf` và `.orchestrator.env` được `eval`: review như script.
- Mỗi task chạy trong git worktree riêng; worktree chỉ có file đã commit nên `SETUP_CMD` được chạy lại trong đó.
- Script chỉ chạy worker nằm trong `WORKERS`; verify cảnh báo file bị sửa ngoài mục "File được phép sửa".
- Cờ của cursor-agent, aider, claude thay đổi theo phiên bản: kiểm tra bằng `--help`.
