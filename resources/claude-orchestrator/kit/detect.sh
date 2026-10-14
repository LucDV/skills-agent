# Được source bởi các script khác: xác định ROOT, nạp cấu hình project + worker.
git rev-parse --git-dir >/dev/null 2>&1 || { echo "Không phải git repo" >&2; exit 1; }
# ROOT luôn là worktree chính, kể cả khi chạy từ trong worktree của task
ROOT=$(git worktree list --porcelain | head -1 | sed 's/^worktree //')

# File sau ghi đè file trước. set -a để biến (API key...) tới được tiến trình con.
set -a
[ -f "$ROOT/.orchestrator.conf" ]      && source "$ROOT/.orchestrator.conf"
[ -f "$ROOT/.orchestrator.env" ]       && source "$ROOT/.orchestrator.env"
[ -f "$ROOT/.orchestrator.env.local" ] && source "$ROOT/.orchestrator.env.local"
set +a

BASE_BRANCH="${BASE_BRANCH:-$(git -C "$ROOT" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@origin/@@' || true)}"
BASE_BRANCH="${BASE_BRANCH:-$(git -C "$ROOT" rev-parse --abbrev-ref HEAD)}"
