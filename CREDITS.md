# Credits

- **oMLX** by Jun Kim and contributors: [jundot/omlx](https://github.com/jundot/omlx), Apache-2.0. This is the engine, and the patches modify it. Tested bases: `main` @ f0d8428a (recommended) and v0.7.0rc1 (DMG).
- **jonathan308** (Jonathan Spangler, [@spangler3000](https://x.com/spangler3000)), for most of the recommended profile's prefill speed: open oMLX PRs for wider Qwen4-Exp prefill steps (#3980, #3981),
  the NAX hyper-connection prefill projections and the depthwise PLE conv (#3982), the pipelined GDN prefill recurrence (#4006), QSA attention on the tensor units (#4020), NAX sorted gather_qmm tiles and the fused MoE gate/up with its SwiGLU epilogue and row map
  (#3993, #3995, #4022, #4029), and wired memory / GPU warm-keeping (#3970, #3974).
- **jerryfane**, for most of the recommended profile's decode speed: bit-exact Lightning MTP verify (#4023), the fused one-token decode kernels (#4024, #4038, #4039),
  and the fused row-exact verify windows for MoE, DeltaNet and attention (#4041).
- **yoyo930021** ([@yoyo930021](https://twitter.com/yoyo930021)), for the Qwen4-Exp QSA KV allocation fixes (#3963, #4030).
- `patches/upstream-omlx-qwen4-stack.patch` is the combined diff of those PRs on f0d8428a, at these heads (2026-09-27): #3970 fba85855, #3974 f4ce2735, #4041 fdac0ac1 (contains #4023, #4024, #4038 and #4039), #3980 d2f1f9e9, #3981 caae927b, #4006 8b50252a, #4020 7e6f2e6b, #4030 f36ca768 (contains #3963), #4029 498685ba (contains #3993, #3995 and #4022).
  Plus two of #3982's three commits (d722fe34, the depthwise PLE conv; 7397ded8, the NAX HC prefill projections), cherry-picked on top.
  Its first commit (44420417, the deferred MLP residual write) is superseded by jerryfane's own deferred write, which the other two work with.
- **Checkpoint:** `mlx-community/Qwen3.8-Flash-Next-oQ6e-mtp` @ `e171af8`. Check its license before redistributing weights; this recipe ships none.
- **Quality reference:** Qwen3.8-Flash-Next BF16 teacher logits, used for the KLD panel.
- **MLX** (Apple), which everything runs on.
