# Results and evidence

Hardware: Mac Studio M5 Ultra, 80-core GPU, 256 GB, macOS 27.0, `iogpu.wired_limit_mb=245760`. Engine: oMLX 0.7.0rc1 (MLX 0.32.2).
Decode tok/s comes from the wall-time difference between 32- and 512-token completions; the agent mix uses streamed completion tokens over (wall − TTFT).
Requests run one at a time, with thinking off.

**MTP depth** (tok/s, fresh · 2K code prompt):

| MTP | T=0 | T=0.6 |
|---|---|---|
| off | 68.9 · 65.0 | 67.9 · 64.1 |
| depth 2 | 138.6 · 120.3 | 135.3 · 112.7 |
| **depth 3** | **145.9 · 120.0** | **148.3 · 115.6** |
| depth 4 | 149.4 · 118.7 | 135.6 · 121.4 |
| adaptive | 145.6 · 112.4 | 146.5 · 117.7 |

**Prompt lookup** (depth 3 on both sides; 7 drafts, 14 when the match runs ≥32 tokens), tok/s:

| task | T=0 | T=0.6 |
|---|---|---|
| return a 140-line file with one rename | 163.8 → 274.6 (1.68×) | 121.3 → 265.0 (2.18×) |
| add docstrings, return the code | 174.5 → 259.1 (1.48×) | 167.2 → 254.0 (1.52×) |
| reproduce a JSON config with one change | 171.5 → 228.8 (1.33×) | 163.7 → 228.6 (1.40×) |
| write a unified diff | 166.3 → 187.4 (1.13×) | 145.9 → 161.3 (1.10×) |
| prose / new code (controls) | flat | flat |

**Greedy text was byte-identical to MTP-only on all six tasks.**
- oMLX's Qwen verify forward is batch-invariant up to 8 rows, so exact acceptance shows up at the text level.
- Lookup rounds accept 76–99 % and land 11.7–14.9 tokens per round.

**Full cell, recipe against stock baseline** (3 stock passes):

| | stock | recipe |
|---|---|---|
| decode fresh greedy | 145.8 · 150.4 · 145.9 | 146.9 |
| decode code 2K, T=0.6 | 127.2 · 118.5 | 165.7 |
| prefill 2K · 32K · 256K | ~2,740–3,010 · 3,381–3,567 · ~3,300–3,321 | 2,783 · 3,579 · 3,321 |
| ladder c=1 · 8 | ~153 · 195 | 155.5 · 193.1 |
| gates | pass | 12/12, all pass incl. vision |

**Quality:** the patch only changes which tokens are drafted; verification is the engine's own. KLD against BF16 is that of the oQ6e checkpoint, 0.0228 (top-1 0.950).
