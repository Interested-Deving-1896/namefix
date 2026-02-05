#!/bin/bash
# namefix installer
# https://github.com/pinkorca/namefix
set -euo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

PREFIX="${PREFIX:-/usr/local}"
BINDIR="${BINDIR:-$PREFIX/bin}"
MANDIR="${MANDIR:-$PREFIX/share/man/man1}"

msg() { echo -e "$1"; }
msg_success() { echo -e "${GREEN}✓${NC} $1"; }
msg_warn() { echo -e "${YELLOW}⚠${NC} $1"; }
msg_error() { echo -e "${RED}✗${NC} $1" >&2; }

usage() {
    cat <<EOF
${BOLD}namefix installer${NC}

Usage: $0 [OPTIONS]

Options:
    install       Install namefix (default)
    uninstall     Remove namefix
    --user        Install to user directories only (no sudo)
    --prefix DIR  Installation prefix (default: /usr/local)
    --help        Show this help

Examples:
    ./install.sh              # System-wide install (may need sudo)
    ./install.sh --user       # User-only install (no sudo needed)
    ./install.sh uninstall    # Remove namefix
EOF
}

check_deps() {
    local missing=()
    command -v bash >/dev/null || missing+=("bash")
    if [[ ${#missing[@]} -gt 0 ]]; then
        msg_error "Missing dependencies: ${missing[*]}"
        exit 1
    fi
}

install_with_sudo() {
    local src="$1" dest="$2" mode="$3"
    if [[ -w "$(dirname "$dest")" ]]; then
        install -m "$mode" "$src" "$dest"
    else
        sudo install -m "$mode" "$src" "$dest"
    fi
}

do_install() {
    local user_only="${1:-false}"

    msg "${BOLD}Installing namefix...${NC}"
    check_deps

    # Binary
    local bindir="$BINDIR"
    if $user_only; then
        bindir="$HOME/.local/bin"
        mkdir -p "$bindir"
    fi

    if [[ -w "$bindir" ]] || $user_only; then
        mkdir -p "$bindir"
        install -m 755 namefix.sh "$bindir/namefix"
        msg_success "Installed binary to $bindir/namefix"
    else
        sudo mkdir -p "$bindir"
        sudo install -m 755 namefix.sh "$bindir/namefix"
        msg_success "Installed binary to $bindir/namefix (with sudo)"
    fi

    # Man page
    if [[ -f "namefix.1" ]]; then
        local mandir="$MANDIR"
        if $user_only; then
            mandir="$HOME/.local/share/man/man1"
        fi

        if [[ -w "$mandir" ]] || $user_only; then
            mkdir -p "$mandir"
            install -m 644 namefix.1 "$mandir/namefix.1"
            msg_success "Installed man page to $mandir/namefix.1"
        else
            sudo mkdir -p "$mandir"
            sudo install -m 644 namefix.1 "$mandir/namefix.1"
            msg_success "Installed man page to $mandir/namefix.1 (with sudo)"
        fi
    fi

    # Bash completion
    if [[ -f "completions/namefix.bash" ]]; then
        local bash_user_dir="$HOME/.local/share/bash-completion/completions"
        local bash_system_dir="/etc/bash_completion.d"

        if $user_only || [[ ! -d "$bash_system_dir" ]]; then
            mkdir -p "$bash_user_dir"
            install -m 644 completions/namefix.bash "$bash_user_dir/namefix"
            msg_success "Installed bash completion to $bash_user_dir"
        elif [[ -d "$bash_system_dir" ]]; then
            if [[ -w "$bash_system_dir" ]]; then
                install -m 644 completions/namefix.bash "$bash_system_dir/namefix"
            else
                sudo install -m 644 completions/namefix.bash "$bash_system_dir/namefix"
            fi
            msg_success "Installed bash completion to $bash_system_dir"
        fi
    fi

    # Zsh completion
    if [[ -f "completions/namefix.zsh" ]]; then
        local zsh_installed=false

        # Try oh-my-zsh first
        if [[ -d "$HOME/.oh-my-zsh" ]]; then
            local zsh_dir="$HOME/.oh-my-zsh/completions"
            mkdir -p "$zsh_dir"
            install -m 644 completions/namefix.zsh "$zsh_dir/_namefix"
            msg_success "Installed zsh completion to $zsh_dir"
            zsh_installed=true
        # Then try user local
        elif [[ -d "$HOME/.zsh" ]] || $user_only; then
            local zsh_dir="$HOME/.local/share/zsh/site-functions"
            mkdir -p "$zsh_dir"
            install -m 644 completions/namefix.zsh "$zsh_dir/_namefix"
            msg_success "Installed zsh completion to $zsh_dir"
            zsh_installed=true
        # Finally try system
        elif [[ -d "/usr/local/share/zsh/site-functions" ]]; then
            local zsh_dir="/usr/local/share/zsh/site-functions"
            if [[ -w "$zsh_dir" ]]; then
                install -m 644 completions/namefix.zsh "$zsh_dir/_namefix"
            else
                sudo install -m 644 completions/namefix.zsh "$zsh_dir/_namefix"
            fi
            msg_success "Installed zsh completion to $zsh_dir"
            zsh_installed=true
        fi

        $zsh_installed || msg_warn "Zsh completion: add completions/namefix.zsh to your fpath"
    fi

    # Fish completion
    if [[ -f "completions/namefix.fish" ]]; then
        local fish_installed=false

        if [[ -d "$HOME/.config/fish" ]]; then
            local fish_dir="$HOME/.config/fish/completions"
            mkdir -p "$fish_dir"
            install -m 644 completions/namefix.fish "$fish_dir/namefix.fish"
            msg_success "Installed fish completion to $fish_dir"
            fish_installed=true
        elif [[ -d "/usr/share/fish/vendor_completions.d" ]] && ! $user_only; then
            local fish_dir="/usr/share/fish/vendor_completions.d"
            if [[ -w "$fish_dir" ]]; then
                install -m 644 completions/namefix.fish "$fish_dir/namefix.fish"
            else
                sudo install -m 644 completions/namefix.fish "$fish_dir/namefix.fish"
            fi
            msg_success "Installed fish completion to $fish_dir"
            fish_installed=true
        fi

        $fish_installed || msg_warn "Fish completion: copy completions/namefix.fish to ~/.config/fish/completions/"
    fi

    echo ""
    msg "${GREEN}${BOLD}Installation complete!${NC}"
    msg "Run 'namefix --help' to get started."

    if $user_only; then
        msg ""
        msg "${YELLOW}Note: Make sure ~/.local/bin is in your PATH${NC}"
    fi
}

do_uninstall() {
    msg "${BOLD}Uninstalling namefix...${NC}"

    local files=(
        # System locations
        "$BINDIR/namefix"
        "$MANDIR/namefix.1"
        "/etc/bash_completion.d/namefix"
        "/usr/local/share/zsh/site-functions/_namefix"
        "/usr/share/fish/vendor_completions.d/namefix.fish"
        # User locations
        "$HOME/.local/bin/namefix"
        "$HOME/.local/share/man/man1/namefix.1"
        "$HOME/.local/share/bash-completion/completions/namefix"
        "$HOME/.oh-my-zsh/completions/_namefix"
        "$HOME/.local/share/zsh/site-functions/_namefix"
        "$HOME/.config/fish/completions/namefix.fish"
    )

    for f in "${files[@]}"; do
        if [[ -f "$f" ]]; then
            if [[ -w "$f" ]]; then
                rm -f "$f"
            else
                sudo rm -f "$f"
            fi
            msg_success "Removed $f"
        fi
    done

    msg "${GREEN}${BOLD}Uninstallation complete.${NC}"
}

main() {
    local action="install"
    local user_only=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            install)
                action="install"
                shift
                ;;
            uninstall)
                action="uninstall"
                shift
                ;;
            --user)
                user_only=true
                shift
                ;;
            --prefix)
                PREFIX="$2"
                BINDIR="$PREFIX/bin"
                MANDIR="$PREFIX/share/man/man1"
                shift 2
                ;;
            --help | -h)
                usage
                exit 0
                ;;
            *)
                msg_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done

    case "$action" in
        install) do_install "$user_only" ;;
        uninstall) do_uninstall ;;
    esac
}

main "$@"
