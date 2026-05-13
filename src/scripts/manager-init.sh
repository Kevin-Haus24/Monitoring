#!/usr/bin/env bash
set -euo pipefail

SWARM_DIR="/home/vagrant/services/.swarm"
MANAGER_IP="${1:-192.168.56.10}"

mkdir -p "$SWARM_DIR"

if [ "$(docker info --format '{{.Swarm.LocalNodeState}}')" != "active" ]; then
  docker swarm init --advertise-addr "$MANAGER_IP"
fi

docker swarm join-token -q worker > "$SWARM_DIR/worker.token"
echo "$MANAGER_IP" > "$SWARM_DIR/manager.ip"
chmod 644 "$SWARM_DIR/worker.token" "$SWARM_DIR/manager.ip"
