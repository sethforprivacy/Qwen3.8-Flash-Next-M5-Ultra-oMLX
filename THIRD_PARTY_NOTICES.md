# Third-party notices

## oMLX (Apache-2.0)

`patches/omlx-0.7.0rc1-qwen-lookup.patch` (DMG profile) and `patches/omlx-main-qwen-on-stack.patch` (recommended profile, applied after the upstream stack) modify files of [oMLX](https://github.com/jundot/omlx), Copyright its authors,
licensed under the Apache License 2.0 ([licenses/omlx-Apache-2.0.txt](licenses/omlx-Apache-2.0.txt)). The patch is distributed under the same license.

Files changed (each change is marked in-code with a "p2" / "Phase-2" comment and sits behind an environment variable):
- `omlx/patches/mlx_lm_mtp/batch_generator.py`: the prompt-lookup hook in the MTP chain cycle, and (recommended profile) the row-exact verify gates `OMLX_P2_ROW_EXACT_MAX_B` / `OMLX_P2_ROW_EXACT_MAX_ROWS`.
- `omlx/patches/p2_lookup.py` (new): prompt-lookup drafts.

## Upstream oMLX pull requests (Apache-2.0)

`patches/upstream-omlx-qwen4-stack.patch` is the combined diff of open oMLX pull requests merged onto f0d8428a in this order:
#3970 fba85855, #3974 f4ce2735, #4041 fdac0ac1 (contains #4023, #4024, #4038 and #4039), #3980 d2f1f9e9, #3981 caae927b, #4006 8b50252a, #4020 7e6f2e6b, #4030 f36ca768 (contains #3963), #4029 498685ba (contains #3993, #3995 and #4022).
The authors are jonathan308 (#3970 #3974 #3980 #3981 #3993 #3995 #4006 #4020 #4022 #4029), jerryfane (#4023 #4024 #4038 #4039 #4041) and yoyo930021 (#3963 #4030).
They are contributions to oMLX under its Apache-2.0 license and are redistributed unchanged. The one exception is the merge of #4029 into #4041, where `qwen35_moe_gate_up.py` keeps both sides' imports.

## Ideas credited, no code copied

- [mlx-serve](https://github.com/ddalcu/mlx-serve) (MIT): prompt-lookup-aware MTP (#523, #533).

## Model (not included)

`mlx-community/Qwen3.8-Flash-Next-oQ6e-mtp` and the upstream Qwen model: check their licenses before use.
