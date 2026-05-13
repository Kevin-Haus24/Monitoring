#!/usr/bin/env bash
set -euo pipefail

SWARM_DIR="/home/vagrant/services/.swarm"
TOKEN_FILE="$SWARM_DIR/worker.token"
MANAGER_FILE="$SWARM_DIR/manager.ip"

if [ "$(docker info --format '{{.Swarm.LocalNodeState}}')" = "active" ]; then
  exit 0
fi

for _ in $(seq 1 90); do
  if [ -s "$TOKEN_FILE" ] && [ -s "$MANAGER_FILE" ]; then
    break
  fi
  sleep 2
done

if [ ! -s "$TOKEN_FILE" ] || [ ! -s "$MANAGER_FILE" ]; then
  echo "Swarm token or manager IP not found in $SWARM_DIR"
  exit 1
fi

WORKER_TOKEN="$(cat "$TOKEN_FILE")"
MANAGER_IP="$(cat "$MANAGER_FILE")"

docker swarm join --token "$WORKER_TOKEN" "$MANAGER_IP:2377"
