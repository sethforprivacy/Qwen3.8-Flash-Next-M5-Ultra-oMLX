# Credits

- **oMLX** by Jun Kim and contributors: [jundot/omlx](https://github.com/jundot/omlx), Apache-2.0. This is the engine, and the patches modify it. Tested bases: `main` @ a98d8c8c (recommended) and v0.7.0rc1 (DMG).
- **jonathan308** (Jonathan Spangler, [@spangler3000](https://x.com/spangler3000)), for most of the recommended profile's prefill speed: wider Qwen4-Exp prefill steps (#3980, #3981),
  exact HC prefill fusions with NAX projections and a depthwise PLE conv (#3982), the pipelined GDN prefill recurrence (#4006), QSA attention on the tensor units (#4020),
  and NAX sorted gather_qmm tiles and the fused MoE gate/up with its SwiGLU epilogue and row map (#3993, #3995, #4022, #4029).
- **jerryfane**, for most of the recommended profile's decode speed: bit-exact Lightning MTP verify (#4023), fused one-token decode kernels (#4024, #4038, #4039),
  and fused row-exact verify windows for MoE, DeltaNet and attention (#4041).
- **jundot** (oMLX's maintainer), for merging all of the above into `main` on 2026-09-28 (the recipe builds on a98d8c8c), reconciling #3982 with the decode chain, and adopting our batched-verify row-exact fix (3c5f1d41).
- **yoyo930021** ([@yoyo930021](https://twitter.com/yoyo930021)), for the Qwen4-Exp QSA KV allocation fixes. #3963 is in `main`; #4030 is open, pinned at 2b13bab9 in `patches/upstream-omlx-qwen4-4030.patch`.
- **Checkpoint:** `mlx-community/Qwen3.8-Flash-Next-oQ6e-mtp` @ `e171af8`. Check its license before redistributing weights; this recipe ships none.
- **Quality reference:** Qwen3.8-Flash-Next BF16 teacher logits, used for the KLD panel.
- **MLX** (Apple), which everything runs on.
