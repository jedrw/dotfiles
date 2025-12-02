#!/bin/bash

# List of menu options
options="Logout\nShutdown\nReboot\nSuspend\nHibernate"

# Show menu via rofi in dmenu mode
choice=$(echo -e "$options" | rofi -dmenu -p "Power:")

# Execute the selected action
case "$choice" in
  Logout) swaymsg exit ;;
  Shutdown) systemctl poweroff ;;
  Reboot) systemctl reboot ;;
  Suspend) systemctl suspend ;;
  Hibernate) systemctl hibernate ;;
esac