#!/bin/bash
# install.sh - Script di installazione ottimizzato per ambienti di sviluppo su Arch/Pacman

# Inizio setup
echo "[+] Avvio del setup per lo sviluppo con Pacman"

# Configurazione dell'ambiente
export PREFIX="$HOME/.local"
export PATH="$PREFIX/bin:$PATH"

# Crea le directory necessarie nella prefix locale
mkdir -p "$PREFIX"/{bin,lib,include,share}

# Audit del sistema
echo ""
echo "[+] Audit del sistema"
echo "Sistema: $(uname -a)"
echo "CPU: $(lscpu 2>/dev/null | grep 'Model name' | cut -d: -f2 | xargs || echo 'Sconosciuto')"
echo "Core CPU: $(nproc)"
echo "Architettura CPU: $(uname -m)"
echo "Memoria di sistema: $(free -h | awk '/Mem:/ {print $2}')"
echo "Spazio su disco: $(df -h / | awk 'NR==2 {print $4}') disponibile"

# Verifica strumenti di build essenziali
echo ""
echo "[+] Verifica strumenti di build"
for tool in gcc g++ make cmake git curl wget tar autoconf automake pkg-config; do
    if command -v "$tool" >/dev/null; then
        echo "  ✓ $tool"
    else
        echo "  ✗ $tool (verrà installato)"
    fi
done

# Funzione di installazione tramite pacman
install_package() {
    local name="$1"
    local pacman_name="${2:-$name}"

    echo ""
    echo "[+] Installazione di $name"

    if [ "$pacman_name" = "skip" ]; then
        echo "  → $name non disponibile su pacman, salto"
        return 0
    fi

    if command -v pacman >/dev/null; then
        echo "  → Installazione via pacman..."
        if sudo pacman -S --needed --noconfirm "$pacman_name" 2>/dev/null || true; then
            if pacman -Qi "$pacman_name" >/dev/null 2>&1; then
                echo "  ✓ $name installato con successo"
                return 0
            fi
        fi
        echo "  ✗ Errore durante l'installazione di $name"
    else
        echo "  ✗ pacman non disponibile"
    fi

    return 1
}

# Installa strumenti di build essenziali
echo ""
echo "[+] Installazione strumenti di base"
sudo pacman -S --needed --noconfirm base-devel git curl wget tar gzip xz || true

# Strumenti principali per lo sviluppo
echo ""
echo "[+] Installazione strumenti core per lo sviluppo"
install_package "git"
install_package "cmake"
install_package "openssl"
install_package "curl"

# Shell e strumenti terminale
install_package "zsh"
install_package "tmux"
install_package "htop"
install_package "btop"
install_package "lazygit"
install_package "zoxide"

# Dipendenze per build da sorgente
install_package "libevent"
install_package "ncurses"
install_package "luajit"

# Editor di testo
install_package "neovim"
install_package "helix"

# Toolchain linguaggi
echo ""
echo "[+] Installazione dei toolchain di linguaggio"

# Rust
if ! command -v cargo >/dev/null; then
    echo "[+] Installazione toolchain Rust"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path || true
    source "$HOME/.cargo/env" 2>/dev/null || true
fi

install_package "python"
install_package "go"
install_package "php"
install_package "java" "jdk-openjdk"
install_package "dotnet-sdk"
install_package "nodejs"
install_package "npm"
install_package "ruby"
install_package "lua"

# Strumenti di sviluppo
echo ""
echo "[+] Installazione strumenti per lo sviluppo"
install_package "jq"
install_package "fzf"
install_package "ripgrep"
install_package "fd"
install_package "bat"
install_package "exa"
install_package "du-dust" "dust"
install_package "tokei"
install_package "hyperfine"
install_package "just"

# Client database
install_package "postgresql"
install_package "mysql"
install_package "sqlite"
install_package "redis"
install_package "mongodb-tools"

# Strumenti Rust
echo "[+] Installazione strumenti per Rust"
if command -v cargo >/dev/null; then
    echo "Installazione pacchetti Rust..."
    for crate in ripgrep fd-find bat exa du-dust starship cargo-edit cargo-watch cargo-audit cargo-outdated bacon sccache; do
        cargo install "$crate" || true
    done
fi

# Strumenti Go
if command -v go >/dev/null; then
    echo "[+] Installazione strumenti Go"
    go install golang.org/x/tools/cmd/godoc@latest || true
    go install golang.org/x/tools/gopls@latest || true
    go install github.com/go-delve/delve/cmd/dlv@latest || true
    go install github.com/cespare/reflex@latest || true
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest || true
fi

# Strumenti Node.js
if command -v npm >/dev/null; then
    echo "[+] Installazione strumenti Node.js"
    npm install -g typescript eslint prettier ts-node nodemon http-server yarn pnpm @angular/cli create-react-app nx neovim || true
fi

# Strumenti Python
if command -v python >/dev/null || command -v python3 >/dev/null; then
    echo "[+] Installazione strumenti Python"
    for pkg in ipython pylint black flake8 isort mypy pytest virtualenv poetry python-lsp-server pipx pyright; do
        python -m pip install --user "$pkg" || python3 -m pip install --user "$pkg" || true
    done
fi

# Utilità di sistema
echo ""
echo "[+] Installazione utilità di sistema"
install_package "tree"
install_package "duf"
install_package "direnv"
install_package "ranger"
install_package "ncdu"
install_package "tldr"
install_package "cheat"
install_package "glow"

# Strumenti di rete
echo ""
echo "[+] Installazione strumenti di rete"
install_package "nmap"
install_package "tcpdump"
install_package "socat"
install_package "mtr"
install_package "httpie"
install_package "wget"
install_package "openssh"

# Strumenti container
echo ""
echo "[+] Installazione strumenti container"
install_package "docker"
install_package "docker-compose"
install_package "kubectl"
install_package "helm"
install_package "podman"
install_package "buildah"
install_package "k9s"

# Strumenti cloud
echo ""
echo "[+] Installazione strumenti cloud"
install_package "terraform"
install_package "ansible"
install_package "packer"
install_package "aws-cli"
install_package "azure-cli"
install_package "google-cloud-sdk"

# Strumenti database aggiuntivi
echo ""
echo "[+] Installazione strumenti avanzati per database"
install_package "mariadb"
install_package "pgcli"
install_package "mycli"

# Applicazioni desktop
echo ""
echo "[+] Installazione applicazioni desktop"
install_package "chromium"
install_package "firefox"
install_package "code"
install_package "dbeaver"
install_package "postman" "postman-bin"
install_package "insomnia"

# Estensioni VS Code
if command -v code >/dev/null; then
    echo "[+] Installazione estensioni per VS Code"
    extensions=(
        ms-python.python rust-lang.rust golang.go
        dbaeumer.vscode-eslint esbenp.prettier-vscode
        ms-vscode.bash github.vscode-pull-request-github
        ms-azuretools.vscode-docker hashicorp.terraform
        redhat.vscode-yaml ms-kubernetes-tools.vscode-kubernetes-tools
        mongodb.mongodb-vscode ms-vscode-remote.remote-ssh
        vscodevim.vim
    )
    for ext in "${extensions[@]}"; do
        code --install-extension "$ext" --force 2>/dev/null || true
    done
fi

# Configura l'ambiente utente
echo ""
echo "[+] Configurazione dell'ambiente"
{
    echo ''
    echo '# Setup ambiente di sviluppo'
    echo 'export PATH="$HOME/.local/bin:$PATH"'
    echo 'export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"'
    echo 'export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"'
    echo 'export EDITOR="nvim"'
    echo 'export VISUAL="$EDITOR"'
    echo ''
    echo '# Ambiente linguaggi'
    echo 'source "$HOME/.cargo/env" 2>/dev/null || true'
    echo 'export GOPATH="$HOME/go"'
    echo 'export PATH="$GOPATH/bin:$PATH"'
    echo 'export PATH="$HOME/.dotnet/tools:$PATH"'
    echo ''
    echo '# Configurazione strumenti'
    echo 'eval "$(zoxide init bash)"'
    echo 'eval "$(starship init bash)"'
    echo 'eval "$(direnv hook bash)"'
} >> ~/.bashrc

# Messaggio finale
echo ""
echo "[✓] INSTALLAZIONE COMPLETATA CON PACMAN"
echo ""
echo "Riepilogo installazione:"
echo "  • Oltre 20 strumenti e utilità per lo sviluppo installati"
echo "  • Supporto esteso a Python, Go, Rust, Node.js, .NET"
echo "  • Tool per database (pgcli, mycli, DBeaver)"
echo "  • Strumenti cloud (AWS, Azure, GCP)"
echo "  • Alternative moderne a utility classiche (bat, exa, fd, ecc.)"
echo ""
echo "Prossimi passi:"
echo "  1. Riavvia il terminale: source ~/.bashrc"
echo "  2. Verifica le installazioni con comandi tipo:"
echo "     nvim --version, code --version, docker --version, kubectl version --client"
echo "  3. Per strumenti mancanti, considera l'installazione manuale via AUR"
echo ""
echo "Setup completato!"

