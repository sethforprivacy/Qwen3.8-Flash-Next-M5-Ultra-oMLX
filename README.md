# Qwen3.8-Flash-Next on a Mac Studio M5 Ultra: oMLX recipe

A recipe for serving **Qwen3.8-Flash-Next** (`mlx-community/Qwen3.8-Flash-Next-oQ6e-mtp`) on one Mac Studio M5 Ultra (80-core GPU, 256 GB) with
[oMLX](https://github.com/jundot/omlx).
- **The build:** a pinned build of oMLX `main` carrying open upstream Qwen4-Exp / MoE performance PRs by jonathan308, jerryfane and yoyo930021 ([CREDITS.md](CREDITS.md)), plus one small patch of ours: **prompt-lookup drafts in oMLX's MTP decoding** and two gates that keep the upstream exact-verify path where it's fast.
- **Quality:** KLD against BF16 is identical to stock oMLX, and every gate passes, vision included.

Companion recipe: [GLM-5.3-Flash on the same machine](https://github.com/sethforprivacy/GLM-5.3-Flash-M5-Ultra-oMLX).

## Two profiles

- **Recommended: oMLX `main` built from source** (@ f0d8428a) + the upstream PR stack (one pinned patch) + the lookup patch.
  It needs git, Xcode and Python 3.11–3.13. The build takes ~10 minutes.
- **Alternative: the oMLX 0.7.0rc1 app (DMG)** + the lookup patch. There's nothing to build, but prefill is ~22–28 % slower and fresh-prompt decode ~11 % slower.

## Results (M5 Ultra 80c / 256 GB, macOS 27.0)

| | stock oMLX 0.7.0rc1 | alternative (rc1 + lookup) | **recommended** |
|---|---|---|---|
| agent edit/copy turns: return a file with a change · add docstrings · reproduce JSON | 164 · 175 · 172 tok/s | 275 · 259 · 229 | **272 · 261 · 230 tok/s** |
| same at T=0.6 | 121 · 167 · 164 | 265 · 254 · 229 | **268 · 252 · 228** |
| prose · new code (T=0) | | 105 · 144 | **115 · 164** |
| prefill 2K · 8K · 32K · 128K · 256K | as the alternative (the lookup patch doesn't touch prefill) | 2,783 · 3,300 · 3,579 · 3,469 · 3,321 | **3,110 · 4,571 · 4,734 · 4,505 · 4,259** |
| decode, fresh prompt (greedy) · 2K code prompt | 146–150 · 112–126 | 147 · 123 | **163–166 · 145–201** |
| aggregate at 1 · 2 · 4 · 8 streams | | 156 · 159 · 170 · 193 | **172 · 169 · 173 · 193** |
| KLD vs BF16: teacher-forced · decode-path | 0.023 | 0.023 | **0.0226 · 0.0268** (stock `main`: 0.0228 · 0.0268) |
| reasoning / tool / long-context / vision gates | pass | 12/12, all pass | **12/12, all pass** |

A 128K-token prompt is read in ~29 s, and a 256K one in ~60 s.

### Choosing an engine for Qwen on this machine

Same suite and box, measured 2026-09-27 (TensorFold re-measured on 0.3.4.1, which fixed its short-prompt prefill):

| | fresh decode | edit turns | prefill 32K | 8 streams | KLD vs BF16 (lower is better) |
|---|---|---|---|---|---|
| **oMLX + this recipe** (oQ6e) | 163–166 | 272 | **4,734** | 193 | **0.023** |
| mlx-serve 26.9.6 (its own mixed 4/8 checkpoint) | 160 | 331 | 3,840 | **236** | 0.035 |
| TensorFold 0.3.4.1 (Vontra 4-bit) | **187** | **338** | 2,324 (689 at 128K) | 180 (no batching) | 0.128 |

- This recipe gives the **best quality** of the three.
- With the upstream PR stack, this recipe also has the **fastest prefill** here (4,734 tok/s at 32K).
- [mlx-serve](https://github.com/ddalcu/mlx-serve) decodes faster, and batches better, at slightly lower quality.
- [TensorFold](https://github.com/ashhart/TensorFold) has the fastest single-stream decode, on a plain 4-bit checkpoint with ~5.5× the KLD.
  Since 0.3.4.1 its prefill matches oMLX at 2K and is 35 % behind at 32K, but it falls to 689 tok/s at 128K and 391 at 256K, and it doesn't batch.

## What changes, and why

| # | Change | Effect |
|---|---|---|
| 1 | *(recommended)* **Open upstream Qwen4-Exp / MoE PRs** ([CREDITS.md](CREDITS.md)).<br>Prefill (jonathan308): wider prefill steps, NAX HC prefill projections and a depthwise PLE conv, the pipelined GDN prefill recurrence, QSA on the tensor units, NAX gather tiles and the fused MoE gate/up.<br>Decode (jerryfane): bit-exact MTP verify, fused one-token decode kernels, and fused verify windows for MoE, DeltaNet and attention.<br>QSA KV allocation fixes (yoyo930021). | prefill +28–38 % at 8K–256K, fresh decode +11–13 % (over rc1); KLD identical |
| 2 | *(recommended)* **Row-exact verify gates** (`OMLX_P2_ROW_EXACT_MAX_B=1`, `OMLX_P2_ROW_EXACT_MAX_ROWS=4`). The upstream exact-verify mode runs every row as a one-row decode. That's fast for one stream's 4-row MTP window, but slow for batched streams and for lookup's 8–15-row verifies, so those keep the batched kernels. | 8 streams 106 → 192 tok/s; edit turns 199 → 273 |
| 3 | **Prompt-lookup drafts in the MTP cycle** (`OMLX_P2_LOOKUP`). When the text being written already appears in the prompt or output (an 8-gram match), the next cycle verifies that earlier continuation instead of an MTP chain: 7 drafts, or 14 when the match runs back ≥32 tokens (mlx-serve #533's rule).<br>Acceptance is the engine's own, with a one-hot draft distribution when sampling, so output is unchanged. Lookup cycles are gated against MTP cycles on measured tokens/s. The idea comes from mlx-serve #523/#533. | 1.3–1.7× on edit turns (up to 2.2× at T=0.6), flat elsewhere |
| 4 | **Fixed MTP depth 3** instead of adaptive. It's within noise of adaptive, and +7 % on code. | small |

## Setup (recommended profile)

1. **Raise the Metal wired-memory limit** to 240 GiB:
   ```bash
   sudo sysctl iogpu.wired_limit_mb=245760
   ```
2. **Build patched oMLX `main`.** This clones oMLX into `~/omlx-qwen-src`, applies the upstream stack and this recipe's patch, builds the native kernels, and checks that they all load.
   ```bash
   scripts/install.sh
   ```
3. **Download the model** (~147 GB). [docs/SETUP.md](docs/SETUP.md) has the pinned revision.
4. **Serve:**
   ```bash
   scripts/serve.sh
   ```
   The server is an OpenAI-compatible endpoint at `http://127.0.0.1:8000/v1`. Send `chat_template_kwargs: {"enable_thinking": false}` when you don't want thinking.

## Setup (alternative: oMLX 0.7.0rc1 DMG, no build)

1. Install `oMLX-0.7.0rc1-macos26-27.dmg` from the [v0.7.0rc1 release](https://github.com/jundot/omlx/releases/tag/v0.7.0rc1)
   (sha256 `82c1ea4d882153bb2da5cd2793e950620b2d2eb81b2e90695272e878be79b83a`) and raise the wired limit as above.
2. Run `scripts/install-dmg.sh`. It copies the app's `Contents/` to `~/omlx-qwen-m5ultra` and applies the patch; the installed app is untouched.
3. Download the model as above, and serve with `scripts/serve-dmg.sh`.

## Known issues

- Lookup is single-stream only (B=1); multi-stream batches use plain MTP.
- **The recommended profile builds on unmerged upstream PRs.** They're pinned in `patches/upstream-omlx-qwen4-stack.patch` at the heads listed in [CREDITS.md](CREDITS.md). As they merge, the recipe will move to an oMLX release that contains them.
- **Combining #3982 with the decode chain:** both add a deferred residual write to the HC kernels, differently. The recipe takes the decode chain's write and #3982's other two commits (NAX HC prefill, PLE conv), which work with it. See THIRD_PARTY_NOTICES.md.

## Credits and license

See [CREDITS.md](CREDITS.md) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). Evidence tables: [docs/RESULTS.md](docs/RESULTS.md). Validation: [docs/VALIDATION.md](docs/VALIDATION.md).

The scripts, configs and docs are MIT ([LICENSE](LICENSE)). The patches modify oMLX, which is Apache-2.0, so they are distributed under Apache-2.0
([licenses/omlx-Apache-2.0.txt](licenses/omlx-Apache-2.0.txt)). No model weights are included.
