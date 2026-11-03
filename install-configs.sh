#!/bin/bash
set -eu

dotfiles_dir="$(cd "$(dirname "$0")" && pwd)"
config_home="${1:-$HOME}"

if [[ "$config_home" != /* ]]; then
    echo "The configuration home must be an absolute path." >&2
    exit 1
fi

link_config() {
    local config_source="$1"
    local config_target="$2"
    local config_backup

    if [[ -L "$config_target" && "$(readlink "$config_target")" == "$config_source" ]]; then
        return
    fi

    if [[ -d "$config_target" ]]; then
        echo "Refusing to replace a directory: $config_target" >&2
        exit 1
    fi

    if [[ -e "$config_target" || -L "$config_target" ]]; then
        config_backup="$(mktemp "${config_target}.before-dotfiles.XXXXXX")"
        if [[ -e "$config_target" ]]; then
            cp -pL "$config_target" "$config_backup"
            chmod 600 "$config_backup"
            rm "$config_target"
        else
            mv "$config_target" "$config_backup"
        fi
        echo "Preserved existing configuration: $config_backup"
    fi

    ln -s "$config_source" "$config_target"
}

mkdir -p "$config_home/.ssh"
chmod 700 "$config_home/.ssh"

link_config "$dotfiles_dir/.gitconfig" "$config_home/.gitconfig"
link_config "$dotfiles_dir/ssh/config" "$config_home/.ssh/config"
chmod 600 "$config_home/.ssh/config"

# Keep personal identity outside the repository and preserve existing overrides.
local_git_config="$config_home/.gitconfig.local"
if [[ ! -e "$local_git_config" ]]; then
    (umask 077; touch "$local_git_config")
fi
for identity_key in user.name user.email user.signingkey; do
    if ! git config --file "$local_git_config" --get "$identity_key" >/dev/null; then
        printf 'Configure your local Git identity: git config --file "%s" %s "VALUE"\n' "$local_git_config" "$identity_key"
    fi
done
