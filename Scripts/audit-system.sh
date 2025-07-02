#!/bin/bash

echo "[+] Auditing system"

echo "CPU cores: $(nproc)"
echo "Package manager: yay (required)"

if ! command -v yay >/dev/null; then
  echo "[-] yay not found"
else
  echo "[✓] yay is installed"
fi

echo "[+] Installed packages summary:"
pacman -Qe > system_report.txt

