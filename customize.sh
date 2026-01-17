#!/system/bin/sh
SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true

print_modname() {
  ui_print "*******************************"
  ui_print "        FRP Module"
  ui_print "*******************************"
}

on_install() {
  ui_print "- Installing FRP..."

  # Default to install client only (server can be enabled via config)
  INSTALL_SERVER=false
  ui_print "- Installing frpc (client) by default"

  # Get latest version
  ui_print "- Fetching latest FRP version..."
  LATEST_RELEASE=$(curl -s https://api.github.com/repos/fatedier/frp/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
  VERSION=${LATEST_RELEASE#v}
  ui_print "- Latest FRP version: $LATEST_RELEASE"

  # Detect architecture
  ARCH=$(uname -m)
  case $ARCH in
    aarch64) FRP_ARCH="android_arm64" ;;
    armv7l) FRP_ARCH="linux_arm" ;;  # Assuming linux_arm for 32-bit arm
    *) ui_print "- Unsupported architecture: $ARCH"; abort "- Installation aborted"; ;;
  esac
  ui_print "- Detected architecture: $ARCH -> $FRP_ARCH"

  # Download FRP binary
  DOWNLOAD_URL="https://github.com/fatedier/frp/releases/download/$LATEST_RELEASE/frp_${VERSION}_${FRP_ARCH}.tar.gz"
  ui_print "- Downloading from: $DOWNLOAD_URL"
  ui_print "- Downloading FRP binary..."
  curl -L -o /tmp/frp.tar.gz "$DOWNLOAD_URL"
  if [ $? -ne 0 ]; then
    ui_print "- Download failed, trying alternative..."
    abort "- Failed to download FRP binary"
  fi
  ui_print "- Download completed"

  # Extract binary
  ui_print "- Extracting FRP binary..."
  mkdir -p /tmp/frp
  tar -xzf /tmp/frp.tar.gz -C /tmp/frp
  if [ $? -ne 0 ]; then
    abort "- Failed to extract FRP binary"
  fi
  ui_print "- Extraction completed"

  # Copy binaries to module
  mkdir -p $MODPATH/system/bin
  cp /tmp/frp/frp*/frpc $MODPATH/system/bin/
  chmod 755 $MODPATH/system/bin/frpc
  if [ "$INSTALL_SERVER" = true ]; then
    cp /tmp/frp/frp*/frps $MODPATH/system/bin/
    chmod 755 $MODPATH/system/bin/frps
    ui_print "- Installed frpc and frps"
  else
    ui_print "- Installed frpc only"
  fi

  # Copy config templates if not exists
  mkdir -p /data/local/tmp
  if [ ! -f "/data/local/tmp/frpc.ini" ]; then
    cp /tmp/frp/frp*/frpc.ini /data/local/tmp/frpc.ini
    ui_print "- Client config template copied to /data/local/tmp/frpc.ini"
  fi
  if [ "$INSTALL_SERVER" = true ] && [ ! -f "/data/local/tmp/frps.ini" ]; then
    cp /tmp/frp/frp*/frps.ini /data/local/tmp/frps.ini
    ui_print "- Server config template copied to /data/local/tmp/frps.ini"
  fi

  # Clean up
  rm -rf /tmp/frp.tar.gz /tmp/frp

  ui_print "- FRP binaries installed successfully"
}

set_permissions() {
  set_perm_recursive $MODPATH 0 0 0755 0644
  set_perm $MODPATH/system/bin/frpc 0 0 0755
  if [ -f "$MODPATH/system/bin/frps" ]; then
    set_perm $MODPATH/system/bin/frps 0 0 0755
  fi
}