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

## 2026-09-27: recommended profile (main + upstream Qwen4-Exp / MoE PR stack + lookup), from scratch

1. `scripts/install.sh` into a fresh tree: every native kernel loads, and the tree is **identical** to the development branch.
   Qwen/MoE test suites in that tree: 2,044 passed and 1 failed. The failure is `test_qwen35_verify_sdpa_split[5000]`, which passes on its own at every merge step: test-order state leakage, not a code defect.
2. Full cell through `scripts/serve.sh`: prefill 3,030 · 4,481 · 4,733 · 4,510 · 4,243 tok/s at 2K–256K, fresh decode 140–141, warm 32K 0.43 s, ladder 150 · 160 · 171 · 191, reasoning 12/12, all qualify gates pass (vision, tool, 127K retrieval).
3. Agent mix: T=0 edit 274.5 · JSON 229.5 · fix 256.5 · diff 185.4 · prose 104.7 · new code 146.6; T=0.6 edit 268.2 · JSON 228.6 · fix 253.4.
4. KLD with the fresh tree's Python, against stock `main` f0d8428a: teacher-forced **0.0226** / top-1 0.9490 (main 0.0228 / 0.9483), decode-path **0.0268** / 0.9332 (main 0.0268 / 0.9332).
