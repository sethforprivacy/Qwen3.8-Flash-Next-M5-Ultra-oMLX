# Third-party notices

## oMLX (Apache-2.0)

`patches/omlx-0.7.0rc1-qwen-lookup.patch` (DMG profile) and `patches/omlx-main-f0d8428a-qwen-lookup.patch` (recommended profile, applied after the upstream stack) modify files of [oMLX](https://github.com/jundot/omlx), Copyright its authors,
licensed under the Apache License 2.0 ([licenses/omlx-Apache-2.0.txt](licenses/omlx-Apache-2.0.txt)). The patch is distributed under the same license.

Files changed (each change is marked in-code with a "p2" comment and sits behind `OMLX_P2_LOOKUP`):
- `omlx/patches/mlx_lm_mtp/batch_generator.py`: the prompt-lookup hook in the MTP chain cycle.
- `omlx/patches/p2_lookup.py` (new): prompt-lookup drafts.

## Upstream oMLX pull requests (Apache-2.0)

`patches/upstream-omlx-qwen4-stack.patch` is the combined diff of nine open oMLX pull requests, merged onto f0d8428a in this order:
#3970 fba85855, #3974 f4ce2735, #4029 498685ba (contains #3993, #3995 and #4022), #3980 d2f1f9e9, #3981 caae927b, #3982 7397ded8, #4006 8b50252a, #4020 7e6f2e6b, #4030 f36ca768 (contains #3963).
The authors are jonathan308, except #3963 and #4030 (yoyo930021). They are contributions to oMLX under its Apache-2.0 license and are redistributed unchanged; all nine merge without conflicts.

## Ideas credited, no code copied

- [mlx-serve](https://github.com/ddalcu/mlx-serve) (MIT): prompt-lookup-aware MTP (#523, #533).

## Model (not included)

`mlx-community/Qwen3.8-Flash-Next-oQ6e-mtp` and the upstream Qwen model: check their licenses before use.
