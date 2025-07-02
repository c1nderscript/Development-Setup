#!/bin/bash
set -e

echo "[+] Starting Development Setup"

# Audit system
./inspect/audit-system.sh

# Bootstrap packages
./setup/bootstrap.sh

# Build performance tools
./setup/core-utils.sh

echo "[✓] Setup complete"

