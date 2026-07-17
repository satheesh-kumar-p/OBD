#!/bin/bash

# 1. Start the Openbox window manager in the background
openbox &
WM_PID=$!

# Give it a moment to initialize the X server display
sleep 2

# 2. Trigger your custom Docker Compose service
systemctl --user start obd-apps.service

# 3. Keep the session alive as long as Openbox is running
wait $WM_PID
