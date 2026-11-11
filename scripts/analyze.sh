#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${SONAR_TOKEN:-}" ]]; then
  echo "Exporte SONAR_TOKEN com um token criado em http://localhost:9090 (My Account, Security)." >&2
  exit 1
fi

root="$(cd "$(dirname "$0")/.." && pwd)"
project="${1:-}"

run_scan() {
  local name="$1"
  local src="$2"
  local props="$3"
  if [[ ! -d "$src" ]]; then
    echo "Diretório ausente: $src" >&2
    exit 1
  fi
  mkdir -p "$root/logs/analysis"
  echo "Analisando $name"
  docker run --rm \
    --network sonarqube-network \
    -e SONAR_HOST_URL=http://sonarqube-experiment:9000 \
    -e SONAR_TOKEN="$SONAR_TOKEN" \
    -v "$src:/usr/src" \
    -v "$props:/usr/src/sonar-project.properties:ro" \
    sonarsource/sonar-scanner-cli \
    | tee "$root/logs/analysis/${name}.log"
}

case "$project" in
  idurar)
    run_scan idurar "$root/projects/idurar-erp-crm" "$root/configs/idurar/sonar-project.properties"
    ;;
  worklenz)
    run_scan worklenz "$root/projects/worklenz" "$root/configs/worklenz/sonar-project.properties"
    ;;
  all|"")
    run_scan idurar "$root/projects/idurar-erp-crm" "$root/configs/idurar/sonar-project.properties"
    run_scan worklenz "$root/projects/worklenz" "$root/configs/worklenz/sonar-project.properties"
    ;;
  *)
    echo "Uso: SONAR_TOKEN=... $0 [idurar|worklenz|all]" >&2
    exit 1
    ;;
esac
