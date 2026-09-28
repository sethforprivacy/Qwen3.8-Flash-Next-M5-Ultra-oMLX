# Changelog




## 2026-09-28 (later): recommended profile v4

- **#3982 back in:** jonathan308's NAX HC prefill projections and depthwise PLE conv, cherry-picked onto jerryfane's decode chain. Its deferred-write commit is superseded by the chain's own, and #3982's bit-identity tests pass with it.
- **Result:** prefill back to 3,110 · 4,571 · 4,734 · 4,505 · 4,259 tok/s (v3: 3,057 · 4,300 · 4,615 · 4,379 · 4,128) with v3's decode (163–166 fresh). Agent turns and concurrency are unchanged, and KLD is identical.

## 2026-09-28: recommended profile v3, decode

- **Upstream stack updated:** it now carries jerryfane's #4041 chain (#4023 #4024 #4038 #4039 #4041: bit-exact MTP verify, fused one-token decode, fused verify windows) in place of jonathan308's #3982, which conflicts with it.
- **Recipe patch** (`patches/omlx-main-qwen-on-stack.patch`): lookup plus two row-exact verify gates.
  - Row-exact at B>1 cost 23–48 % at 4–8 streams.
  - Row-exact on lookup's long verifies cost 27 % on edit turns.
- **Result:** fresh decode 158–165 (v2: 140–141), prose / new code +9–12 %, edit turns unchanged, 8 streams 192. Prefill −3 % (3,057 · 4,300 · 4,615 · 4,379 · 4,128). KLD identical to stock `main`. Validated from scratch.

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
