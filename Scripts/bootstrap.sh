#!/bin/bash
set -e

echo "[+] Bootstrapping packages"

# If yay is missing, build it
if ! command -v yay >/dev/null; then
  echo "[+] Installing yay from source"
  sudo pacman -S --needed base-devel git
  git clone https://aur.archlinux.org/yay.git
  cd yay && makepkg -si && cd ..
fi

echo "[+] Installing core packages"
yay -S --needed zsh tmux htop neovim curl chromium kleopatra redis

echo "[+] Installing desktop applications"
yay -S --needed discord signal-desktop tor-browser warp-terminal

echo "[+] Installing language toolchains"
yay -S --needed rust rust-analyzer cargo lld go gopls delve \
  python ipython python-pip python-lsp-server \
  nodejs npm typescript eslint prettier \
  php composer lua luarocks

echo "[+] Installing compilers and build tools"
yay -S --needed git git-lfs gcc clang cmake make automake

echo "[+] Installing VS Code and extensions"
yay -S --needed visual-studio-code-bin

extensions=(
  ms-python.python rust-lang.rust golang.go
  dbaeumer.vscode-eslint esbenp.prettier-vscode
  ms-vscode.bash github.vscode-pull-request-github
)

for ext in "${extensions[@]}"; do
  code --install-extension "$ext"
done

echo "[+] Installing global NPM packages"
npm install -g eslint prettier typescript ts-node vite nodemon http-server eslint_d prettier_d

echo "[+] Installing global Rust developer tools"
cargo install cargo-edit cargo-watch cargo-audit cargo-outdated cargo-expand ripgrep fd-find bat exa

echo "[+] Installing global Python developer tools"
pip install --user ipython pylint black flake8 isort mypy pytest virtualenv python-lsp-server

echo "[✓] All language environments initialized"

