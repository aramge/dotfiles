#!/usr/bin/env bash
DIR="$(dirname "$(readlink -f "$0")")"
HOST=$(hostname)

assemble() {
    echo "// Generiert am $(date)" > "$DIR/config.kdl"
    cat "$DIR/common.kdl" "$DIR/${HOST}.kdl" >> "$DIR/config.kdl"
}

# Initialer Bau
assemble

# Überwachung: Sobald sich common oder die Host-Datei ändert, neu bauen
while inotifywait -e close_write "$DIR/common.kdl" "$DIR/${HOST}.kdl"; do
    assemble
done
