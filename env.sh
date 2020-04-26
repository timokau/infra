#!/usr/bin/env bash
#
# A little bash wrapps that sets-up the build environment for this project
#
# Usage: source env.sh
# Usage: ./env.sh <command>
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  set -euo pipefail
fi

__env_setup() {
  local here
  here=$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")

  # Env vars
  #NIX_PATH=$(nix-instantiate "$here/nix/sources.nix" -A pkgs.nixpkgs --eval --json | xargs)
  #export NIX_PATH

  # Switch the config home to this project
  local xdg_config_home="${XDG_CONFIG_HOME:-$HOME/.cache}"
  export XDG_CONFIG_HOME=$here/config
  export XDG_CONFIG_DIRS=$xdg_config_home${XDG_CACHE_DIRS+:$XDG_CONFIG_DIRS:}

  # Cleanup after itself
  unset __env_setup
}
__env_setup

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  exec "$@"
fi
