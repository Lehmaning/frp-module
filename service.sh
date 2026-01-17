#!/system/bin/sh

MODDIR=${0%/*}

# Load configuration
[ -f "$MODDIR/config.sh" ] && . "$MODDIR/config.sh"

# Default config path
FRP_CONFIG=${FRP_CONFIG:-/data/local/tmp/frpc.ini}

# Check if config file exists
if [ ! -f "$FRP_CONFIG" ]; then
  exit 1
fi

# Start FRP
if [ "$FRP_MODE" = "server" ]; then
  /system/bin/frps -c "$FRP_CONFIG" &
else
  /system/bin/frpc -c "$FRP_CONFIG" &
fi
sleep 2