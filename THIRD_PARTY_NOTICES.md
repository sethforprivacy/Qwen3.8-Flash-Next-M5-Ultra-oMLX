# Third-party notices

## oMLX (Apache-2.0)

`patches/omlx-0.7.0rc1-qwen-lookup.patch` (and its `main` variant) modifies files of [oMLX](https://github.com/jundot/omlx), Copyright its authors,
licensed under the Apache License 2.0 ([licenses/omlx-Apache-2.0.txt](licenses/omlx-Apache-2.0.txt)). The patch is distributed under the same license.

Files changed (each change is marked in-code with a "p2" comment and sits behind `OMLX_P2_LOOKUP`):
- `omlx/patches/mlx_lm_mtp/batch_generator.py`: the prompt-lookup hook in the MTP chain cycle.
- `omlx/patches/p2_lookup.py` (new): prompt-lookup drafts.

## Ideas credited, no code copied

- [mlx-serve](https://github.com/ddalcu/mlx-serve) (MIT): prompt-lookup-aware MTP (#523, #533).

## Model (not included)

`mlx-community/Qwen3.8-Flash-Next-oQ6e-mtp` and the upstream Qwen model: check their licenses before use.
