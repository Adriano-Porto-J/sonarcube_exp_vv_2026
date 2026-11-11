#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
example="$root/projects/worklenz/.env.example"
target="$root/projects/worklenz/.env"

if [[ ! -f "$example" ]]; then
  echo "Clone o Worklenz em projects/worklenz antes de gerar o .env." >&2
  exit 1
fi

if [[ -f "$target" ]]; then
  echo "$target já existe. Nada foi alterado."
  exit 0
fi

python3 - "$example" "$target" <<'PY'
import secrets, sys
from pathlib import Path
src, dest = map(Path, sys.argv[1:3])
text = src.read_text()
replacements = {
    "DB_PASSWORD=CHANGE_THIS_SECURE_PASSWORD_123": "DB_PASSWORD=" + secrets.token_hex(16),
    "SESSION_SECRET=CHANGE_THIS_TO_RANDOM_HEX_STRING_32_CHARS": "SESSION_SECRET=" + secrets.token_hex(32),
    "COOKIE_SECRET=CHANGE_THIS_TO_RANDOM_HEX_STRING_32_CHARS": "COOKIE_SECRET=" + secrets.token_hex(32),
    "JWT_SECRET=CHANGE_THIS_TO_RANDOM_HEX_STRING_32_CHARS": "JWT_SECRET=" + secrets.token_hex(32),
    "REDIS_PASSWORD=CHANGE_THIS_REDIS_PASSWORD": "REDIS_PASSWORD=" + secrets.token_hex(16),
    "S3_SECRET_ACCESS_KEY=CHANGE_THIS_SEAWEEDFS_SECRET": "S3_SECRET_ACCESS_KEY=" + secrets.token_hex(16),
}
for old, new in replacements.items():
    if old not in text:
        raise SystemExit(f"Linha esperada não encontrada em .env.example: {old.split('=', 1)[0]}")
    text = text.replace(old, new, 1)
secret = next(line.split("=", 1)[1] for line in text.splitlines() if line.startswith("S3_SECRET_ACCESS_KEY="))
if "AWS_SECRET_ACCESS_KEY=" not in text:
    text += f"\nAWS_SECRET_ACCESS_KEY={secret}\n"
dest.write_text(text)
PY

chmod 600 "$target"
echo "Arquivo local criado: $target"
