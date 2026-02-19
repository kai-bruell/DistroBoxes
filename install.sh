#!/bin/bash
# Install all distroboxes defined in subdirectories via distrobox assemble
set -e

export DISTROBOXES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for dir in "$DISTROBOXES_DIR"/*/; do
    ini_file=$(find "$dir" -maxdepth 1 -name "*.ini" | head -1)
    if [ -n "$ini_file" ]; then
        echo "==> Installing distrobox from $ini_file"
        tmp_ini=$(mktemp)
        sed "s|\$DISTROBOXES_DIR|$DISTROBOXES_DIR|g" "$ini_file" > "$tmp_ini"
        distrobox assemble create --file "$tmp_ini"
        rm "$tmp_ini"
    fi
done
