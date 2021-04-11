# ! /bin/sh
# For Choko Hack 10.0.0+

RUNNINGFROM="$(dirname "$(realpath "$0")")"

  # Put files in FAT partition
  cp -R "$RUNNINGFROM/opt"/* /opt/
  cp "$RUNNINGFROM/opt/joystickmode/jshid.sh.XYZ" /opt/joystickmode/jshid.sh
  cp "$RUNNINGFROM/joystickmode.nfo" /.choko/games2S.nfo
  cp "$RUNNINGFROM/joystickmode2S.sh" /.choko/games2S.sh
  # If this is the first list of games being copied then install the menu
  [ -x /.choko/usb_exec.sh ] || ( cp "$RUNNINGFROM/usb_exec.sh" /.choko/ ; cp "$RUNNINGFROM"/*.rgba /.choko/ )
  echo -e "Menu option assigned to [P2 START]."

[ -x /.choko/usb_exec.sh ] && exec "/.choko/usb_exec.sh" || exec "$RUNNINGFROM/usb_exec.sh"
