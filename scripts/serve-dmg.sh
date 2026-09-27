#!/bin/zsh
# ALTERNATIVE (no build): the oMLX 0.7.0rc1 app route. The recommended profile is scripts/install.sh + scripts/serve.sh.
# Serve Qwen3.8-Flash-Next from the patched oMLX tree with the recipe settings.
#   scripts/serve-dmg.sh [model-dir] [port]
# model-dir holds the model folder Qwen3.8-Flash-Next-oQ6e-mtp (default ~/models/mlx). oMLX loads it on first request (~147 GB).
set -euo pipefail
here=${0:A:h}
models=${1:-$HOME/models/mlx}
port=${2:-8000}
omlx=${OMLX_RECIPE_TREE:-$HOME/omlx-qwen-m5ultra}

export OMLX_P2_LOOKUP=1 OMLX_P2_LOOKUP_MAX_LONG=14
settings=$here/../configs/model_settings.qwen.json

mkdir -p ~/.omlx
if [[ -f ~/.omlx/model_settings.json ]] && ! cmp -s $settings ~/.omlx/model_settings.json; then
  cp ~/.omlx/model_settings.json ~/.omlx/model_settings.json.bak.$(date +%s)
fi
cp $settings ~/.omlx/model_settings.json
# --memory-guard-gb: keep oMLX's own guard below the Metal wired limit. Raise that limit first with
#   sudo sysctl iogpu.wired_limit_mb=245760     (240 GiB on a 256 GB machine)
# Prefix (KV) cache on SSD, capped: without a cap it grew to its 200 GB default on our box.
ssd=${OMLX_RECIPE_SSD_CACHE:-$HOME/.omlx/ssd-cache}
mkdir -p $ssd
exec $omlx/Contents/MacOS/omlx-cli serve --model-dir $models --host 127.0.0.1 --port $port \
  --max-concurrent-requests 8 --memory-guard-gb 232 \
  --paged-ssd-cache-dir $ssd --paged-ssd-cache-max-size ${OMLX_RECIPE_SSD_CACHE_MAX:-50GB} --log-level info
