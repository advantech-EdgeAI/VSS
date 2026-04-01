#!/bin/bash

set -euo pipefail

PULL_OPTIONAL=0

usage() {
    echo "Usage: $0 [--with-optional]"
    echo "  --with-optional  Also pull optional observability images (default: skip)"
    exit 1
}

for arg in "$@"; do
    case "$arg" in
        --with-optional) PULL_OPTIONAL=1 ;;
        -h|--help) usage ;;
        *) echo "[ERROR] Unknown argument: $arg" >&2; usage ;;
    esac
done

FAILED=()
PASSED=()

pull() {
    local img="$1"
    echo ">>> Pulling: $img"
    if docker pull "$img"; then
        PASSED+=("$img")
    else
        echo "[ERROR] Failed to pull: $img" >&2
        FAILED+=("$img")
    fi
}

# Check docker is available
if ! command -v docker &>/dev/null; then
    echo "[ERROR] docker not found in PATH" >&2
    exit 1
fi

if ! docker info &>/dev/null; then
    echo "[ERROR] Docker daemon is not running or not accessible" >&2
    exit 1
fi

echo "========================================"
echo " Pulling required images"
echo "========================================"
pull ispsae/vllm:jetson-thor-llama31-8B
pull ispsae/pytorch-25.08-emb-rank:v1.0.0
pull ispsae/jp71-vss-engine:v2.4.1
pull neo4j:5.26.16
pull arangodb:3.12.6
pull minio/minio:RELEASE.2025-09-07T16-13-09Z
pull milvusdb/milvus:v2.6.5
pull elasticsearch:9.2.1

if [ "$PULL_OPTIONAL" -eq 1 ]; then
    echo ""
    echo "========================================"
    echo " Pulling optional images"
    echo "========================================"
    pull otel/opentelemetry-collector-contrib:latest
    pull prom/prometheus:latest
    pull jaegertracing/all-in-one:latest
else
    echo ""
    echo "(Skipping optional images. Use --with-optional to include them.)"
fi

echo ""
echo "========================================"
echo " Summary"
echo "========================================"
echo "Succeeded: ${#PASSED[@]}"
for img in "${PASSED[@]}"; do echo "  [OK]   $img"; done

if [ ${#FAILED[@]} -gt 0 ]; then
    echo "Failed:    ${#FAILED[@]}"
    for img in "${FAILED[@]}"; do echo "  [FAIL] $img"; done
    exit 1
fi

echo "All images pulled successfully."
