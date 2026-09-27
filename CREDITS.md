# Credits

- **oMLX** by Jun Kim and contributors: [jundot/omlx](https://github.com/jundot/omlx), Apache-2.0. This is the engine, and the patches modify it. Tested bases: `main` @ f0d8428a (recommended) and v0.7.0rc1 (DMG).
- **jonathan308** (Jonathan Spangler), for most of the recommended profile's prefill speed: open oMLX PRs for wider Qwen4-Exp prefill steps (#3980, #3981),
  exact HC prefill fusions and a depthwise PLE conv kernel (#3982), the pipelined GDN prefill recurrence (#4006), QSA attention on the tensor units (#4020),
  NAX sorted gather_qmm tiles and the fused MoE gate/up with its SwiGLU epilogue and row map (#3993, #3995, #4022, #4029), and wired memory / GPU warm-keeping (#3970, #3974).
- **yoyo930021**, for the Qwen4-Exp QSA KV allocation fixes (#3963, #4030).
- `patches/upstream-omlx-qwen4-stack.patch` is the combined diff of those PRs on f0d8428a, at these heads (2026-09-27): #3970 fba85855, #3974 f4ce2735, #4029 498685ba (contains #3993, #3995 and #4022), #3980 d2f1f9e9, #3981 caae927b, #3982 7397ded8, #4006 8b50252a, #4020 7e6f2e6b, #4030 f36ca768 (contains #3963).
- **mlx-serve** by ddalcu: [ddalcu/mlx-serve](https://github.com/ddalcu/mlx-serve), MIT.
  Prompt-lookup-aware MTP ([#523](https://github.com/ddalcu/mlx-serve/pull/523), [#533](https://github.com/ddalcu/mlx-serve/pull/533)) is the idea behind this patch,
  including the 14-drafts-on-long-match rule. Our implementation is independent Python for oMLX.
- **Checkpoint:** `mlx-community/Qwen3.8-Flash-Next-oQ6e-mtp` @ `e171af8`. Check its license before redistributing weights; this recipe ships none.
- **Quality reference:** Qwen3.8-Flash-Next BF16 teacher logits, used for the KLD panel.
- **MLX** (Apple), which everything runs on.
