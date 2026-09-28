# Third-party notices

## oMLX (Apache-2.0)

`patches/omlx-0.7.0rc1-qwen-lookup.patch` (DMG profile) and `patches/omlx-main-qwen-on-stack.patch` (recommended profile, applied after the upstream stack) modify files of [oMLX](https://github.com/jundot/omlx), Copyright its authors,
licensed under the Apache License 2.0 ([licenses/omlx-Apache-2.0.txt](licenses/omlx-Apache-2.0.txt)). The patch is distributed under the same license.

Files changed (each change is marked in-code with a "p2" / "Phase-2" comment and sits behind an environment variable):
- `omlx/patches/mlx_lm_mtp/batch_generator.py`: the prompt-lookup hook in the MTP chain cycle, and (recommended profile) the row-exact verify row limit `OMLX_P2_ROW_EXACT_MAX_ROWS`.
- `omlx/patches/p2_lookup.py` (new): prompt-lookup drafts.

## Upstream oMLX pull request (Apache-2.0)

`patches/upstream-omlx-qwen4-4030.patch` is yoyo930021's open pull request [#4030](https://github.com/jundot/omlx/pull/4030) (head 2b13bab9), merged onto oMLX `main` @ a98d8c8c without conflicts.
It is a contribution to oMLX under its Apache-2.0 license and is redistributed unchanged.

## Ideas credited, no code copied

- [mlx-serve](https://github.com/ddalcu/mlx-serve) (MIT): prompt-lookup-aware MTP (#523, #533).

## Model (not included)

`mlx-community/Qwen3.8-Flash-Next-oQ6e-mtp` and the upstream Qwen model: check their licenses before use.
