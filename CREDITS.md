# Credits

- **oMLX** by Jun Kim and contributors: [jundot/omlx](https://github.com/jundot/omlx), Apache-2.0. This is the engine, and the patch modifies it. Tested base: v0.7.0rc1.
- **mlx-serve** by ddalcu: [ddalcu/mlx-serve](https://github.com/ddalcu/mlx-serve), MIT.
  Prompt-lookup-aware MTP ([#523](https://github.com/ddalcu/mlx-serve/pull/523), [#533](https://github.com/ddalcu/mlx-serve/pull/533)) is the idea behind this patch,
  including the 14-drafts-on-long-match rule. Our implementation is independent Python for oMLX.
- **Checkpoint:** `mlx-community/Qwen3.8-Flash-Next-oQ6e-mtp` @ `e171af8`. Check its license before redistributing weights; this recipe ships none.
- **Quality reference:** Qwen3.8-Flash-Next BF16 teacher logits, used for the KLD panel.
- **MLX** (Apple), which everything runs on.
