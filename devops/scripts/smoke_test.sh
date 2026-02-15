#!/usr/bin/env bash
set -euo pipefail

# Simple smoke test for the backend API
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HEALTH_URL="http://127.0.0.1:8000/health"
RECOMMEND_URL="http://127.0.0.1:8000/recommend"

echo "Using workspace root: $ROOT_DIR"

echo "\n1) Checking /health..."
if command -v jq >/dev/null 2>&1; then
  curl -sS "$HEALTH_URL" | jq .
else
  curl -sS "$HEALTH_URL"
fi

echo "\n2) POST /recommend (example payload)"
PAYLOAD='{
  "scent": "vanilla",
  "zodiac": "taurus",
  "coffee": "latte",
  "age": 30,
  "genres": ["mystery","fantasy"]
}'

if command -v jq >/dev/null 2>&1; then
  curl -sS -X POST "$RECOMMEND_URL" -H "Content-Type: application/json" -d "$PAYLOAD" | jq .
else
  curl -sS -X POST "$RECOMMEND_URL" -H "Content-Type: application/json" -d "$PAYLOAD"
fi

echo "\nSmoke test completed successfully."
