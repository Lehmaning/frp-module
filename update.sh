#!/system/bin/sh

MODDIR=${0%/*}

# Check for updates
check_update() {
  local current_version="1.0.0"  # Update this with current version
  local latest_release=$(curl -s https://api.github.com/repos/Lehmaning/frp-module/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

  if [ "$latest_release" != "v$current_version" ]; then
    echo "New version available: $latest_release. Please update the module."
  else
    echo "Module is up to date."
  fi
}

check_update