#!/bin/zsh
# RECOMMENDED profile: oMLX main @ f0d8428a built from source, plus open upstream Qwen4-Exp / MoE PRs (9 PRs, mostly jonathan308's,
# pinned as one patch: see CREDITS.md for the PR heads) and this recipe's prompt-lookup patch on top. Native kernels included.
#   scripts/install.sh [~/omlx-qwen-src]
# Needs git, Xcode (with its Metal toolchain) and Python 3.11-3.13.
set -euo pipefail
here=${0:A:h}
dest=${1:-$HOME/omlx-qwen-src}
py=""
for c in python3.12 python3.13 python3.11; do command -v $c >/dev/null && { py=$c; break; }; done
[[ -n $py ]] || { echo "need python 3.11, 3.12 or 3.13 on PATH" >&2; exit 1; }
xcrun -f metal >/dev/null 2>&1 || { echo "need Xcode's Metal toolchain (xcrun metal)" >&2; exit 1; }
[[ -e $dest ]] && { echo "$dest exists; remove it first" >&2; exit 1; }
git clone -q https://github.com/jundot/omlx.git $dest
cd $dest
git checkout -q f0d8428a
git apply $here/../patches/upstream-omlx-qwen4-stack.patch
git add -A && git -c user.name=recipe -c user.email=recipe@localhost commit -q -m "upstream Qwen4-Exp / MoE PR stack"
git apply $here/../patches/omlx-main-f0d8428a-qwen-lookup.patch
git add -A && git -c user.name=recipe -c user.email=recipe@localhost commit -q -m "mac-studio-m5-ultra recipe patch"
$py -m venv .venv
. .venv/bin/activate
python -m pip install -q --upgrade pip
# The kernel build imports mlx (for its CMake extension helper) and must match its ABI: mlx 0.32.2 is the pin in pyproject.toml.
python -m pip install -q "setuptools>=68" wheel "cmake>=3.27" "nanobind==2.15.0" "mlx==0.32.2"
# Without OMLX_WITH_CUSTOM_KERNEL=1 the install silently builds no native kernels.
OMLX_WITH_CUSTOM_KERNEL=1 python -m pip install -q --no-build-isolation -e .
python - <<'PY'
from omlx.custom_kernels import native_kernel_status
s = {k: v["available"] for k, v in native_kernel_status().items()}
print("native kernels:", s)
raise SystemExit(0 if all(s.values()) else 1)
PY
echo "patched oMLX main ready at $dest"
