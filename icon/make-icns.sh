#!/bin/bash
# Convertit todoist-server.svg en ICNS et l'applique à TodoistServer.app

set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
SVG="$DIR/todoist-server.svg"
ICONSET="$DIR/icon.iconset"
APP="$HOME/Applications/TodoistServer.app"

# ── 1. Convertir SVG → PNG 1024px ────────────────────────────────────────
echo "Conversion SVG → PNG..."
if command -v rsvg-convert &>/dev/null; then
  rsvg-convert -w 1024 -h 1024 "$SVG" -o "$DIR/icon_1024.png"
elif command -v convert &>/dev/null; then
  convert -background none -resize 1024x1024 "$SVG" "$DIR/icon_1024.png"
else
  echo "❌  Installe librsvg (brew install librsvg) ou ImageMagick (brew install imagemagick)"
  exit 1
fi

# ── 2. Générer le .iconset ────────────────────────────────────────────────
echo "Génération des tailles..."
rm -rf "$ICONSET" && mkdir "$ICONSET"
for SIZE in 16 32 64 128 256 512; do
  sips -z $SIZE $SIZE "$DIR/icon_1024.png" --out "$ICONSET/icon_${SIZE}x${SIZE}.png"    >/dev/null
  sips -z $((SIZE*2)) $((SIZE*2)) "$DIR/icon_1024.png" \
       --out "$ICONSET/icon_${SIZE}x${SIZE}@2x.png" >/dev/null
done

# ── 3. Compiler en ICNS ───────────────────────────────────────────────────
echo "Compilation ICNS..."
iconutil -c icns "$ICONSET" -o "$DIR/todoist-server.icns"

# ── 4. Appliquer à l'app ──────────────────────────────────────────────────
if [ -d "$APP" ]; then
  RESOURCES="$APP/Contents/Resources"
  # Trouver le fichier icns existant
  EXISTING=$(find "$RESOURCES" -name "*.icns" | head -1)
  if [ -n "$EXISTING" ]; then
    cp "$DIR/todoist-server.icns" "$EXISTING"
    # Forcer le rafraîchissement de l'icône
    touch "$APP"
    /System/Library/CoreServices/CoreServicesUIAgent.app/Contents/MacOS/CoreServicesUIAgent &
    echo "✅  Icône appliquée à $APP"
  else
    echo "⚠️  Aucun fichier .icns trouvé dans $RESOURCES — copie manuelle :"
    echo "    cp $DIR/todoist-server.icns $RESOURCES/"
  fi
else
  echo "⚠️  $APP introuvable — vérifie le chemin de l'app."
fi

echo "Fichiers générés dans $DIR/"
