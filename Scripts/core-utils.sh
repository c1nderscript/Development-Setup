#!/bin/bash
set -e

echo "[+] Building performance-critical tools from source"

echo "[+] Compiling Neovim from source"
yay -G neovim && cd neovim
make CMAKE_BUILD_TYPE=Release -j$(nproc)
sudo make install
cd ..

# Optional: goxlr-utility-ui or warp-terminal build
# Add conditional build flags if needed

