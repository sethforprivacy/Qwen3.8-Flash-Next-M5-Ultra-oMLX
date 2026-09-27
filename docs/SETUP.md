# Setup details

Use a Hugging Face token (`hf auth login`) to avoid rate limits. Keep models in a folder Spotlight doesn't index, e.g. `~/models.noindex/mlx`, with a symlink at `~/models/mlx`.

```bash
hf download mlx-community/Qwen3.8-Flash-Next-oQ6e-mtp --revision e171af86f499f1855b0fb71d781105e8dd609610 \
  --local-dir ~/models/mlx/Qwen3.8-Flash-Next-oQ6e-mtp
```

## Checking that it worked

- Each finished request logs `MTP[<id>] … accept=…`.
- Requests that copy text also log `P2-LOOKUP[<id>] rounds=… accepted=… (9x %) tok/round=…`. With 14-token long-match drafts, a round lands 11–15 tokens.

## Memory

Peak system RAM is ~172 GB during a 256K-token prefill.
