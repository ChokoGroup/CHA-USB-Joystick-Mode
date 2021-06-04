#! /bin/sh
# USB Joystick Mode
# For Choko Hack 12.0.0+

FNAME=${0##*/}
if [ "$FNAME" = "S12usbjoysticksmode" ] && [ "$1" = "start" ]
then
  {
  # CHA is running in USB Joystick Mode
  PRESSED="0000000000000000"
  echo -e "\nPress \e[1;94m[P1 START]\e[m and \e[1;94m[P2 START]\e[m to restore CHA system."
  COUNTDOWN=5
  until [ "$PRESSED" = "0000001000000010" ] || [ $COUNTDOWN -eq 0 ]
  do
    echo -ne "\rWaiting $COUNTDOWN seconds... "
    sleep 1
    COUNTDOWN=$((COUNTDOWN - 1))
    PRESSED=$(readjoysticks j1 j2 -b)
  done
  echo -ne "\r\e[K"
  if [ "$PRESSED" = "0000001000000010" ]
  then
    echo "Restoring CHA system..."
    WASOK=0
    mkdir -p /tmp/flash
    BOOTDISK=$(cat /proc/cmdline); BOOTDISK=${BOOTDISK#*'root=/dev/'}; BOOTDISK=${BOOTDISK%'p2 '*}
    mount /dev/${BOOTDISK}p1 /tmp/flash
    cp /opt/usbjoysticksmode/sun8i-h3-orangepi-pc.dtb.original /tmp/flash/sun8i-h3-orangepi-pc.dtb; WASOK=$?
    umount /tmp/flash 2>/dev/null
    if [ $WASOK -eq 0 ]
    then
      echo -e "\nCHA system successfully restored."
      rm /etc/init.d/S12usbjoysticksmode; /etc/init.d/S11chokopoweroff rebootnow
    else
      echo -e "\n\e[1;31mThere was some error.\e[m"
      sleep 10
      /etc/init.d/S11chokopoweroff rebootnow
    fi
  else

    # Insert required modules
    insmod /opt/usbjoysticksmode/configfs.ko; insmod /opt/usbjoysticksmode/libcomposite.ko; insmod /opt/usbjoysticksmode/usb_f_hid.ko

    # Mount configfs
    mkdir -p /tmp/config
    mount -t configfs none /tmp/config

    # Create 8 button joystick gadget
    mkdir -p /tmp/config/usb_gadget/8_buttons_joystick

    # Define USB specification
    echo 0x1d6b > /tmp/config/usb_gadget/8_buttons_joystick/idVendor # Linux Foundation
    echo 0x0104 > /tmp/config/usb_gadget/8_buttons_joystick/idProduct # Multifunction Composite Joystick Gadget
    echo 0x0100 > /tmp/config/usb_gadget/8_buttons_joystick/bcdDevice # v1.0.0
    echo 0x0200 > /tmp/config/usb_gadget/8_buttons_joystick/bcdUSB # USB2
    echo 0xEF > /tmp/config/usb_gadget/8_buttons_joystick/bDeviceClass
    echo 0x02 > /tmp/config/usb_gadget/8_buttons_joystick/bDeviceSubClass
    echo 0x01 > /tmp/config/usb_gadget/8_buttons_joystick/bDeviceProtocol

    # Perform localization
    mkdir -p /tmp/config/usb_gadget/8_buttons_joystick/strings/0x409
    echo "JJ0" > /tmp/config/usb_gadget/8_buttons_joystick/strings/0x409/serialnumber
    printf "Koch Media - Choko - jj0" > /tmp/config/usb_gadget/8_buttons_joystick/strings/0x409/manufacturer
    printf "Capcom Home Arcade Joystick" > /tmp/config/usb_gadget/8_buttons_joystick/strings/0x409/product

    # Define the functions of the device
    mkdir -p /tmp/config/usb_gadget/8_buttons_joystick/functions/hid.usb0
    echo 0 > /tmp/config/usb_gadget/8_buttons_joystick/functions/hid.usb0/protocol
    echo 0 > /tmp/config/usb_gadget/8_buttons_joystick/functions/hid.usb0/subclass
    echo 2 > /tmp/config/usb_gadget/8_buttons_joystick/functions/hid.usb0/report_length

    mkdir -p /tmp/config/usb_gadget/8_buttons_joystick/functions/hid.usb1
    echo 0 > /tmp/config/usb_gadget/8_buttons_joystick/functions/hid.usb1/protocol
    echo 0 > /tmp/config/usb_gadget/8_buttons_joystick/functions/hid.usb1/subclass
    echo 2 > /tmp/config/usb_gadget/8_buttons_joystick/functions/hid.usb1/report_length

    # Gamepad (2 bits X, 2 bit Y and 1 bit x8 buttons)
    echo -ne \\x05\\x01\\x09\\x05\\xA1\\x01\\x15\\xFF\\x25\\x01\\x09\\x30\\x09\\x31\\x75\\x02\\x95\\x02\\x81\\x02\\x75\\x01\\x95\\x04\\x81\\x03\\x05\\x09\\x19\\x01\\x29\\x08\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x08\\x81\\x02\\xC0 > /tmp/config/usb_gadget/8_buttons_joystick/functions/hid.usb0/report_desc
    echo -ne \\x05\\x01\\x09\\x05\\xA1\\x01\\x15\\xFF\\x25\\x01\\x09\\x30\\x09\\x31\\x75\\x02\\x95\\x02\\x81\\x02\\x75\\x01\\x95\\x04\\x81\\x03\\x05\\x09\\x19\\x01\\x29\\x08\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x08\\x81\\x02\\xC0 > /tmp/config/usb_gadget/8_buttons_joystick/functions/hid.usb1/report_desc

    # Create configuration file
    mkdir -p /tmp/config/usb_gadget/8_buttons_joystick/configs/c.1/strings/0x409
    echo 0x80 > /tmp/config/usb_gadget/8_buttons_joystick/configs/c.1/bmAttributes
    echo 100 > /tmp/config/usb_gadget/8_buttons_joystick/configs/c.1/MaxPower # 100 mA
    echo "Capcom Home Arcade Joystick Configuration" > /tmp/config/usb_gadget/8_buttons_joystick/configs/c.1/strings/0x409/configuration

    # Link the configuration file
    ln -s /tmp/config/usb_gadget/8_buttons_joystick/functions/hid.usb0 /tmp/config/usb_gadget/8_buttons_joystick/configs/c.1
    ln -s /tmp/config/usb_gadget/8_buttons_joystick/functions/hid.usb1 /tmp/config/usb_gadget/8_buttons_joystick/configs/c.1

    # Activate device
    ls /sys/class/udc > /tmp/config/usb_gadget/8_buttons_joystick/UDC

    # Start joysticks forwarders in background
    /opt/usbjoysticksmode/js2hid /dev/input/event2 /dev/hidg0 &
    /opt/usbjoysticksmode/js2hid /dev/input/event3 /dev/hidg1 &
    
    echo "CHA is now in USB Joysticks mode."
    # Hold boot forever
    while true
    do
      sleep 1000
    done
  fi
  } > /dev/tty0
  # ^This redirects text output to be visible on screen
  
else
  # Activate USB Joysticks Mode
  mkdir -p /tmp/flash
  BOOTDISK=$(cat /proc/cmdline); BOOTDISK=${BOOTDISK#*'root=/dev/'}; BOOTDISK=${BOOTDISK%'p2 '*}
  mount /dev/${BOOTDISK}p1 /tmp/flash

  WASOK=0
  if [ ! -e /opt/usbjoysticksmode/sun8i-h3-orangepi-pc.dtb.original ]
  then
    cp /tmp/flash/sun8i-h3-orangepi-pc.dtb /opt/usbjoysticksmode/sun8i-h3-orangepi-pc.dtb.original; WASOK=$?
  fi
  if [ $WASOK -eq 0 ]
  then
    cp /opt/usbjoysticksmode/sun8i-h3-orangepi-pc.dtb.usbjoysticksmode /tmp/flash/sun8i-h3-orangepi-pc.dtb; WASOK=$?
  fi
  if [ $WASOK -eq 0 ]
  then
    cp "$0" /etc/init.d/S12usbjoysticksmode; WASOK=$?
  else
    cp /opt/usbjoysticksmode/sun8i-h3-orangepi-pc.dtb.original /tmp/flash/sun8i-h3-orangepi-pc.dtb
  fi

  umount /tmp/flash 2>/dev/null

  if [ $WASOK -eq 0 ]
  then
   echo -e "\nRebooting into USB Joysticks mode..."
  else
    echo -e "\n\e[1;31mThere was some error.\e[m"
  fi
  sleep 3
  # Call for safe unmount and reboot
  exit 200
fi
