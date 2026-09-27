# Validation log

## 2026-09-26/27: from scratch on the M5 Ultra

1. **Combined-patch run (2026-09-26):** `scripts/install.sh` into a fresh tree from `/Applications/oMLX.app` 0.7.0rc1, then a full cell through the serve script:

   | | recipe, from scratch | dev tree |
   |---|---|---|
   | decode fresh greedy | 145.2 | 146.9 |
   | prefill 2K · 32K · 256K | 2,924 · 3,574 · 3,324 | 2,783 · 3,579 · 3,321 |
   | ladder c=1 · 8 | 155.0 · 192.2 | 155.5 · 193.1 |
   | gates | 12/12; all pass incl. vision | 12/12; all pass |

   That run used the combined patch, which also carried GLM-only changes that Qwen never exercises.
2. **This recipe's 2-file lookup-only patch** (`patches/omlx-0.7.0rc1-qwen-lookup.patch`), 2026-09-27: `scripts/install.sh` from scratch, then `scripts/serve.sh`.
   - Agent mix at T=0: greedy text byte-identical to the dev-tree run on all 6 tasks. Reasoning 12/12, and every qualify gate passes, vision and 127K retrieval included.
   - That run also exposed the lookup-gate cold-sample bug: edit_file came in at 242 vs 275 tok/s with identical text. See the CHANGELOG.
3. **After the gate fix**, two fresh installs, each with a freshly started server: edit · json · fix · diff · prose · new code =
   266.0 · 228.6 · 258.1 · 187.4 · 104.7 · 143.9 and 273.9 · 228.9 · 259.0 · 187.4 · 104.9 · 143.8 tok/s
   (published: 274.6 · 228.8 · 259.1 · 187.4 · 105.0 · 143.9). Greedy text was identical on all 6 tasks in both runs.
