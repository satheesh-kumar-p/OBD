#!/bin/bash

# 1. Set up the Wayland environment variables
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export WAYLAND_DISPLAY=wayland-0

# 2. Start the labwc compositor in the background
labwc &
LABWC_PID=$!

# Give labwc a couple of seconds to initialize its Wayland sockets
sleep 2

# 3. Export the GUI environment to systemd --user (from your File 4)
# This is crucial so your user service knows where to draw the windows
systemctl --user import-environment WAYLAND_DISPLAY XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS

# 4. Trigger your custom Docker Compose service
systemctl --user start obd-apps.service

# 5. Keep the session alive as long as labwc is running
wait $LABWC_PID
