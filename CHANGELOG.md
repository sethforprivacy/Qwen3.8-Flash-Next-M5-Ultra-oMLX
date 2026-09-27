# Changelog


## 2026-09-27 (night): recommended profile on oMLX `main` + upstream PR stack

- **New recommended profile:** oMLX `main` @ f0d8428a + nine open upstream Qwen4-Exp / MoE PRs (mostly jonathan308's; pinned in `patches/upstream-omlx-qwen4-stack.patch`) + the lookup patch, built by `scripts/install.sh`.
  Prefill 3,030 · 4,481 · 4,733 · 4,510 · 4,243 tok/s at 2K–256K (rc1 route: 2,783 · ~3,300 · 3,579 · 3,469 · 3,321). Agent turns are unchanged; greedy fresh decode is ~4 % lower (upstream #3958). KLD is identical to stock `main`. Validated from scratch.
- The rc1 DMG route becomes the no-build alternative: `scripts/install-dmg.sh`, `scripts/serve-dmg.sh`.

## 2026-09-27: first release (split from the combined M5 Ultra recipe)

- Lookup gate fix: the first timed cycle at each new verify width is kept out of the tokens/s EMAs. It pays one-off Metal kernel compilation, and one such cold sample had gated short-match lookups off for most of a request (a Qwen edit task measured 242 vs 275 tok/s with identical output). Gate decisions only; output is unchanged.
- oMLX 0.7.0rc1 patch (2 files): prompt-lookup drafts in the MTP cycle, with 14 drafts on ≥32-token matches. Fixed MTP depth 3.
- `main` @ f0d8428a variant of the patch (docs/OMLX-MAIN.md).
- Engine comparison against mlx-serve 26.9.6 and TensorFold 0.3.4 on the same machine.
- Companion: https://github.com/sethforprivacy/GLM-5.3-Flash-M5-Ultra-oMLX
