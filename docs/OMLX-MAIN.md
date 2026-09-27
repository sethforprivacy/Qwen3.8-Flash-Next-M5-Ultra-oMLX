> **History.** This page predates the recommended `main` profile (README). That profile adds the upstream PR stack (`patches/upstream-omlx-qwen4-stack.patch`) under the same lookup patch and is built by `scripts/install.sh`.

# Optional: oMLX `main` built from source

The lookup patch is rebased onto oMLX `main` @ [`f0d8428a`](https://github.com/jundot/omlx/commit/f0d8428a) as `patches/omlx-main-f0d8428a-qwen-lookup.patch`.
Upstream #3958 split the MTP chain cycle, and the hook sits in the new `draft_next()`.

| | 0.7.0rc1 stock | 0.7.0rc1 + recipe | main stock | main + recipe |
|---|---|---|---|---|
| decode fresh · code 2K | 146–150 · 112–126 | 146.9 · 122.7 | 142.6 · 118.9 | 140.8 · 117.7 |
| prefill 8K · 32K | ~3,300 · 3,381–3,567 | 3,300 · 3,579 | 3,286 · 3,785 | 3,293 · **3,879** |
| gates | pass | pass | | 12/12 · all pass |

**Heads-up:** upstream #3958 (on `main`) costs greedy MTP decode on M5 Ultra: −9 % at fixed depth 3, −3 % adaptive ([jundot/omlx#4021](https://github.com/jundot/omlx/issues/4021)). It helps top-k-sampled decoding. For greedy use, the rc1 DMG route is faster today.

Single runs, and Qwen decode varies ±3–4 % between runs. `main` currently brings a little more prefill for Qwen, but no decode change for oQ6e:
#3912's fused routed-expert decode only takes 4-bit experts.

## Build

```bash
git clone https://github.com/jundot/omlx.git ~/omlx-src && cd ~/omlx-src && git checkout f0d8428a
git apply /path/to/recipe/patches/omlx-main-f0d8428a-qwen-lookup.patch
python3.12 -m venv .venv && . .venv/bin/activate
pip install "setuptools>=68" wheel "cmake>=3.27" "nanobind==2.15.0"
OMLX_WITH_CUSTOM_KERNEL=1 pip install --no-build-isolation -e .
```

Without `OMLX_WITH_CUSTOM_KERNEL=1`, the install silently builds no native kernels. Serve with the same flags and environment as `scripts/serve.sh`, replacing the binary with `~/omlx-src/.venv/bin/omlx serve`.
