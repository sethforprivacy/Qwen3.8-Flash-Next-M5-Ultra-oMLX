# Qwen3.8-Flash-Next on a Mac Studio M5 Ultra: oMLX recipe

A recipe for serving **Qwen3.8-Flash-Next** (`mlx-community/Qwen3.8-Flash-Next-oQ6e-mtp`) on one Mac Studio M5 Ultra (80-core GPU, 256 GB) with
[oMLX](https://github.com/jundot/omlx) 0.7.0rc1, plus one small patch (2 files) that adds **prompt-lookup drafts to oMLX's MTP decoding**.
- Output is exact: greedy text was byte-identical to MTP-only on every test task, and sampling stays exact.
- The patch sits behind an environment variable ([docs/ENVS.md](docs/ENVS.md)).

Companion recipe: [GLM-5.3-Flash on the same machine](https://github.com/sethforprivacy/GLM-5.3-Flash-M5-Ultra-oMLX).

## Results (M5 Ultra 80c / 256 GB, macOS 27.0)

| | stock oMLX 0.7.0rc1 | this recipe |
|---|---|---|
| agent edit/copy turns (MTP-only baseline): return a file with a change · add docstrings · reproduce JSON | 164 · 175 · 172 tok/s | **275 · 259 · 229 tok/s** (1.68× · 1.48× · 1.33×) |
| same at T=0.6 | 121 · 167 · 164 | **265 · 254 · 229** (up to 2.18×) |
| decode, 2K-token code prompt (T=0.6) | 118–127 | **166** |
| decode, fresh prompt (greedy) | 146–150 | 147 (unchanged) |
| prose, new code, prefill (3,300–3,580 tok/s), concurrency | | unchanged |
| KLD vs BF16 | 0.023 (oQ6e) | 0.023 |
| reasoning / tool / long-context / vision gates | pass | 12/12, all pass |

### Choosing an engine for Qwen on this machine

Same suite and box, measured 2026-09-27 (TensorFold re-measured on 0.3.4.1, which fixed its short-prompt prefill):

| | fresh decode | edit turns | prefill 32K | 8 streams | KLD vs BF16 (lower is better) |
|---|---|---|---|---|---|
| **oMLX + this recipe** (oQ6e) | 147 | 275 | 3,579 | 193 | **0.023** |
| mlx-serve 26.9.6 (its own mixed 4/8 checkpoint) | 160 | 331 | **3,840** | **236** | 0.035 |
| TensorFold 0.3.4.1 (Vontra 4-bit) | **187** | **338** | 2,324 (689 at 128K) | 180 (no batching) | 0.128 |

- This recipe gives the **best quality** of the three.
- [mlx-serve](https://github.com/ddalcu/mlx-serve) is faster overall at slightly lower quality.
- [TensorFold](https://github.com/ashhart/TensorFold) has the fastest single-stream decode, on a plain 4-bit checkpoint with ~5.5× the KLD.
  Since 0.3.4.1 its prefill matches oMLX at 2K and is 35 % behind at 32K, but it falls to 689 tok/s at 128K and 391 at 256K, and it doesn't batch.

## What changes, and why

| # | Change | Effect |
|---|---|---|
| 1 | **Prompt-lookup drafts in the MTP cycle.** When the text being written already appears in the prompt or output (an 8-gram match), the next cycle verifies that earlier continuation instead of an MTP chain: 7 drafts, or 14 when the match runs back ≥32 tokens (mlx-serve #533's rule). Acceptance is the engine's own, with a one-hot draft distribution when sampling, so output is unchanged. Lookup cycles are gated against MTP cycles on measured tokens/s. Idea from mlx-serve #523/#533. | 1.3–1.7× on edit turns (up to 2.2× at T=0.6), flat elsewhere |
| 2 | **Fixed MTP depth 3** instead of adaptive. Within noise of adaptive, and +7 % on code. | small |

## Setup

1. **Install oMLX 0.7.0rc1:** `oMLX-0.7.0rc1-macos26-27.dmg` from the [v0.7.0rc1 release](https://github.com/jundot/omlx/releases/tag/v0.7.0rc1)
   (sha256 `82c1ea4d882153bb2da5cd2793e950620b2d2eb81b2e90695272e878be79b83a`). Drag it to `/Applications`.
2. **Raise the Metal wired-memory limit** to 240 GiB:
   ```bash
   sudo sysctl iogpu.wired_limit_mb=245760
   ```
3. **Build the patched tree.** This copies the app's `Contents/` to `~/omlx-qwen-m5ultra` and applies the patch. The installed app is untouched.
   ```bash
   scripts/install.sh
   ```
4. **Download the model** (~147 GB). [docs/SETUP.md](docs/SETUP.md) has the pinned revision.
5. **Serve:**
   ```bash
   scripts/serve.sh
   ```
   The server is an OpenAI-compatible endpoint at `http://127.0.0.1:8000/v1`. Send `chat_template_kwargs: {"enable_thinking": false}` when you don't want thinking.

## Known issues

- Lookup is single-stream only (B=1); multi-stream batches use plain MTP.

## Credits and license

See [CREDITS.md](CREDITS.md) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). Evidence tables: [docs/RESULTS.md](docs/RESULTS.md). Validation: [docs/VALIDATION.md](docs/VALIDATION.md).

The scripts, configs and docs are MIT ([LICENSE](LICENSE)). The patch modifies oMLX, which is Apache-2.0, so it is distributed under Apache-2.0
([licenses/omlx-Apache-2.0.txt](licenses/omlx-Apache-2.0.txt)). No model weights are included.
