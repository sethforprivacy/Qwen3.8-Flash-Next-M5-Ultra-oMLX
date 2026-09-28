# Environment toggles

Both profiles use the same variables (`scripts/serve.sh` and `scripts/serve-dmg.sh`). Unset means stock oMLX behaviour. The upstream PR stack in the recommended profile needs no variables: its kernels switch on by themselves on M5 (NAX) GPUs.

| Variable | Recipe value | Stock | What it does | Evidence |
|---|---|---|---|---|
| `OMLX_P2_LOOKUP` | `1` | `0` | Prompt-lookup drafts in the MTP cycle (8-gram match, exact acceptance, gated against MTP). | 1.3–1.7× on edit/copy turns, flat on prose |
| `OMLX_P2_ROW_EXACT_MAX_ROWS` | `4` (patch default) | *(recommended only)* all | Arms the upstream row-exact MTP verify (single-stream windows only, upstream) only for windows of at most N rows (an MTP depth-3 window). The 8–15-row verifies of prompt-lookup rounds are faster on the batched kernels; acceptance stays exact. | edit turns 199 → 273 tok/s |
| `OMLX_P2_LOOKUP_MAX_LONG` | `14` | `= OMLX_P2_LOOKUP_MAX` | Drafts when the match runs back ≥32 tokens. | edits 1.47× → 1.68×, greedy text identical |

Model settings (`configs/model_settings.qwen.json`, installed by both serve scripts): MTP on, fixed depth 3.

Tuning knobs, left at their defaults: `OMLX_P2_LOOKUP_NGRAM` (8), `OMLX_P2_LOOKUP_MAX` (7), `OMLX_P2_LOOKUP_LONG` (32), `OMLX_P2_LOOKUP_GATE` (1).
- A flat 14-draft cap (`OMLX_P2_LOOKUP_MAX=14`) is slightly slower than the long-match rule.
- It also changes greedy text on some prompts, because verify blocks larger than 8 rows take a different qmm kernel.
