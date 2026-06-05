#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# setup-vps.sh — Arranca Paperclip en un VPS Ubuntu limpio (22.04/24.04).
#
# Qué hace:
#   1. Instala Docker + Docker Compose plugin y git.
#   2. Clona el código de Paperclip en ./paperclip (junto a este repo).
#   3. Crea un .env a partir de .env.example si no existe, con un
#      BETTER_AUTH_SECRET aleatorio generado automáticamente.
#   4. Construye y levanta Paperclip con docker compose (UI/API en el puerto 3100).
#
# Uso (desde la raíz de este repo, en el VPS):
#   chmod +x scripts/setup-vps.sh
#   sudo ./scripts/setup-vps.sh
#
# Después: edita .env para poner tu ANTHROPIC_API_KEY, y luego importa las
# empresas (ver deploy/PRODUCTION.md).
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PAPERCLIP_SRC="${REPO_DIR}/paperclip"

log() { printf "\n\033[1;34m==> %s\033[0m\n" "$*"; }

# 1. Dependencias del sistema ────────────────────────────────────────────────
log "Instalando dependencias (docker, git)…"
if ! command -v docker >/dev/null 2>&1; then
  apt-get update -y
  apt-get install -y ca-certificates curl git
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    > /etc/apt/sources.list.d/docker.list
  apt-get update -y
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
  echo "Docker ya está instalado."
fi

# 2. Clonar Paperclip ────────────────────────────────────────────────────────
log "Obteniendo el código de Paperclip…"
if [ ! -d "${PAPERCLIP_SRC}/.git" ]; then
  git clone --depth 1 https://github.com/paperclipai/paperclip.git "${PAPERCLIP_SRC}"
else
  git -C "${PAPERCLIP_SRC}" pull --ff-only || true
fi

# 3. Preparar .env ───────────────────────────────────────────────────────────
log "Preparando .env…"
if [ ! -f "${REPO_DIR}/.env" ]; then
  cp "${REPO_DIR}/.env.example" "${REPO_DIR}/.env"
  SECRET="$(openssl rand -hex 32)"
  # Rellena BETTER_AUTH_SECRET automáticamente.
  sed -i "s|^BETTER_AUTH_SECRET=.*|BETTER_AUTH_SECRET=${SECRET}|" "${REPO_DIR}/.env"
  echo ".env creado con un BETTER_AUTH_SECRET aleatorio."
  echo "⚠️  Edita .env y añade tu ANTHROPIC_API_KEY antes de usar agentes Claude."
else
  echo ".env ya existe; no lo toco."
fi

# 4. Levantar Paperclip ──────────────────────────────────────────────────────
log "Construyendo y levantando Paperclip (puede tardar varios minutos la 1ª vez)…"
cd "${REPO_DIR}"
PAPERCLIP_SRC="${PAPERCLIP_SRC}" docker compose up -d --build

log "Listo."
echo "Paperclip está arrancando. Comprueba el estado con:"
echo "    docker compose logs -f paperclip"
echo "Cuando esté listo, la UI/API responde en el puerto 3100 del servidor."
echo "Siguiente paso: importar las empresas (ver deploy/PRODUCTION.md)."
