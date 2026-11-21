#!/usr/bin/env bash
# Compila la versión web en Vercel: instala Flutter (con caché entre builds) y genera build/web.
set -euo pipefail
FLUTTER_VERSION="3.50.0"
FLUTTER_DIR="${HOME}/flutter-${FLUTTER_VERSION}"
if [ ! -x "${FLUTTER_DIR}/bin/flutter" ]; then
  git clone --depth 1 --branch "${FLUTTER_VERSION}" https://github.com/flutter/flutter.git "${FLUTTER_DIR}"
fi
export PATH="${FLUTTER_DIR}/bin:${PATH}"
flutter --disable-analytics >/dev/null 2>&1 || true
flutter config --no-cli-animations >/dev/null 2>&1 || true
flutter pub get
flutter build web --release
