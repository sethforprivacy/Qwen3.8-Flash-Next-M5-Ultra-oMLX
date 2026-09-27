#!/bin/zsh
# Build a patched oMLX tree from the official oMLX 0.7.0rc1 app, leaving the installed app untouched.
#   scripts/install.sh [/Applications/oMLX.app] [~/omlx-qwen-m5ultra]
# The app is copied (Contents/ only). The recipe patch is applied to Contents/Resources/omlx, and the copy runs through its own
# bundled Python via scripts/serve.sh. The copy never auto-updates; delete it and re-run this to rebuild.
set -euo pipefail
here=${0:A:h}
app=${1:-/Applications/oMLX.app}
dest=${2:-$HOME/omlx-qwen-m5ultra}
patch=$here/../patches/omlx-0.7.0rc1-qwen-lookup.patch

ver=$(defaults read "$app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null || echo "?")
if [[ $ver != 0.7.0rc1* ]]; then
  echo "expected oMLX 0.7.0rc1 at $app, found '$ver'. Install oMLX-0.7.0rc1-macos26-27.dmg" \
       "(sha256 82c1ea4d882153bb2da5cd2793e950620b2d2eb81b2e90695272e878be79b83a) from https://github.com/jundot/omlx/releases/tag/v0.7.0rc1" >&2
  exit 1
fi
if [[ -e $dest ]]; then echo "$dest exists; remove it first" >&2; exit 1; fi
mkdir -p $dest
cp -R "$app/Contents" $dest/
cd $dest/Contents/Resources/omlx
git init -q && git add -A && git -c user.name=recipe -c user.email=recipe@localhost commit -q -m "oMLX 0.7.0rc1 as shipped"
git apply --check $patch
git apply $patch
git add -A && git -c user.name=recipe -c user.email=recipe@localhost commit -q -m "mac-studio-m5-ultra recipe patch"
echo "patched oMLX tree ready at $dest (git log in $dest/Contents/Resources/omlx)"
