#! /bin/sh
# Joystick Mode
# For Choko Hack 10.0.0+

FNAME=${0##*/}
if [ "$FNAME" = "usb_exec.sh" ]
then
  # CHA is running in Joystick Mode
  CHA2S="0"
  echo -e "\nPress \e[1;94m[P2 START]\e[m to restore CHA system."
  COUNTDOWN=6
  while [ "$CHA2S" = "0" ] && [ $COUNTDOWN -gt 0 ]
  do
    COUNTDOWN=$((COUNTDOWN - 1))
    echo -ne "\rWaiting $COUNTDOWN seconds... "
    sleep 1
    /usr/sbin/evtest --query /dev/input/event3 EV_KEY BTN_BASE
    CHA2S=$?
  done
  if [ "$CHA2S" = "10" ]
  then
    echo "Restoring CHA system..."
    WASOK=0
    cp /.choko/S21capcom /etc/init.d/; WASOK=$?
    if [ $WASOK -eq 0 ]
    then
      cp /.choko/usb_exec.sh.original /.choko/usb_exec.sh
    fi
    if [ $WASOK -eq 0 ]
    then
      mkdir -p /tmp/flash
      BOOTDISK=$(cat /proc/cmdline); BOOTDISK=${BOOTDISK#*'root=/dev/'}; BOOTDISK=${BOOTDISK%'p2 '*}
      mount /dev/${BOOTDISK}p1 /tmp/flash
      cp /opt/joystickmode/sun8i-h3-orangepi-pc.dtb.original /tmp/flash/sun8i-h3-orangepi-pc.dtb; WASOK=$?
    fi

    umount /tmp/flash 2>/dev/null

    if [ $WASOK -eq 0 ]
    then
     echo -e "\n CHA system successfully restored."
    else
      echo -e "\n\e[1;31mThere was some error.\e[m"; sleep 10
    fi
    # Call for safe unmount and reboot
    exit 200
  else
    cd /opt/joystickmode
    ./jshid.sh
  fi
else
  # Activate Joystick mode
  mkdir -p /tmp/flash
  BOOTDISK=$(cat /proc/cmdline); BOOTDISK=${BOOTDISK#*'root=/dev/'}; BOOTDISK=${BOOTDISK%'p2 '*}
  mount /dev/${BOOTDISK}p1 /tmp/flash

  WASOK=0
  if [ ! -e /opt/joystickmode/sun8i-h3-orangepi-pc.dtb.original ]
  then
    cp /tmp/flash/sun8i-h3-orangepi-pc.dtb /opt/joystickmode/sun8i-h3-orangepi-pc.dtb.original; WASOK=$?
  fi
  if [ $WASOK -eq 0 ]
  then
    cp /opt/joystickmode/sun8i-h3-orangepi-pc.dtb.joysticksmode /tmp/flash/sun8i-h3-orangepi-pc.dtb; WASOK=$?
  fi
  if [ $WASOK -eq 0 ]
  then
    cp /.choko/usb_exec.sh /.choko/usb_exec.sh.original; WASOK=$?
  else
    cp /opt/joystickmode/sun8i-h3-orangepi-pc.dtb.original /tmp/flash/sun8i-h3-orangepi-pc.dtb
  fi
  if [ $WASOK -eq 0 ]
  then
    cp /.choko/games2S.sh /.choko/usb_exec.sh; WASOK=$?
  fi
  if [ $WASOK -eq 0 ]
  then
    mv /etc/init.d/S21capcom /.choko/; WASOK=$?
  else
    cp /.choko/usb_exec.sh.original /.choko/usb_exec.sh
  fi

  umount /tmp/flash 2>/dev/null

  if [ $WASOK -eq 0 ]
  then
   echo -e "\nJoystick mode activated. Press [P2 START] at boot to restore CHA system."
  else
    echo -e "\n\e[1;31mThere was some error.\e[m"; sleep 10
  fi
  # Call for safe unmount and reboot
  exit 200
fi
