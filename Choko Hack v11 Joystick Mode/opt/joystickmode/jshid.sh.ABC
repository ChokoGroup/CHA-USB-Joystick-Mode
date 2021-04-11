#!/bin/sh
# Original design for Raspberry Pi at https://github.com/milador/RaspberryPi-Joystick
# Additional info on Windows recognising Composite USB Device with multiple functions
# at https://irq5.io/2016/12/22/raspberry-pi-zero-as-multiple-usb-gadgets/

# Where am I
CDIR=`pwd`

#Kill arcade carousel
killall capcom

# Insert required modules
insmod configfs.ko;insmod libcomposite.ko;insmod usb_f_hid.ko;insmod joydev.ko

# Mount configfs
mkdir /tmp/config
mount -t configfs none /tmp/config

# Create 8 button joystick gadget
cd /tmp/config/usb_gadget/
mkdir -p 8_buttons_joystick
cd 8_buttons_joystick

# Define USB specification
echo 0x1d6b > idVendor # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Joystick Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB # USB2
echo 0xEF > bDeviceClass
echo 0x02 > bDeviceSubClass
echo 0x01 > bDeviceProtocol

# Perform localization
mkdir -p strings/0x409

echo "JJ0" > strings/0x409/serialnumber
printf "Koch Media - Choko - jj0" > strings/0x409/manufacturer
printf "CapcomHomeArcade Joystick" > strings/0x409/product

# Define the functions of the device
mkdir functions/hid.usb0
echo 0 > functions/hid.usb0/protocol
echo 0 > functions/hid.usb0/subclass
echo 2 > functions/hid.usb0/report_length

mkdir functions/hid.usb1
echo 0 > functions/hid.usb1/protocol
echo 0 > functions/hid.usb1/subclass
echo 2 > functions/hid.usb1/report_length

# Gamepad (2 bits X, 2 bit Y and 8 buttons)
# echo -ne \\x05\\x01\\x09\\x05\\xA1\\x01\\x15\\xFF\\x25\\x01\\x09\\x30\\x09\\x31\\x75\\x02\\x95\\x02\\x81\\x02\\x75\\x01\\x95\\x04\\x81\\x03\\x05\\x09\\x19\\x01\\x29\\x08\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x08\\x81\\x02\\xC0 > functions/hid.usb0/report_desc
# echo -ne \\x05\\x01\\x09\\x05\\xA1\\x01\\x15\\xFF\\x25\\x01\\x09\\x30\\x09\\x31\\x75\\x02\\x95\\x02\\x81\\x02\\x75\\x01\\x95\\x04\\x81\\x03\\x05\\x09\\x19\\x01\\x29\\x08\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x08\\x81\\x02\\xC0 > functions/hid.usb1/report_desc
echo -ne \\x05\\x01\\x09\\x05\\xA1\\x01\\x15\\xFF\\x25\\x01\\x09\\x30\\x09\\x31\\x75\\x02\\x95\\x02\\x81\\x02\\x75\\x01\\x95\\x04\\x81\\x03\\x05\\x09\\x19\\x01\\x29\\x06\\x09\\x08\\x09\\x07\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x08\\x81\\x02\\xC0 > functions/hid.usb0/report_desc
echo -ne \\x05\\x01\\x09\\x05\\xA1\\x01\\x15\\xFF\\x25\\x01\\x09\\x30\\x09\\x31\\x75\\x02\\x95\\x02\\x81\\x02\\x75\\x01\\x95\\x04\\x81\\x03\\x05\\x09\\x19\\x01\\x29\\x06\\x09\\x08\\x09\\x07\\x15\\x00\\x25\\x01\\x75\\x01\\x95\\x08\\x81\\x02\\xC0 > functions/hid.usb1/report_desc

# Create configuration file
mkdir -p configs/c.1/strings/0x409

echo 0x80 > configs/c.1/bmAttributes
echo 100 > configs/c.1/MaxPower # 100 mA
echo "CapcomHomeArcade Joystick Configuration" > configs/c.1/strings/0x409/configuration

# Link the configuration file
ln -s functions/hid.usb0 configs/c.1
ln -s functions/hid.usb1 configs/c.1

# Activate device
ls /sys/class/udc > UDC

# Back to where I was
cd $CDIR

# Start joysticks forwarders in background
./js2hid /dev/input/js0 /dev/hidg0 &
sleep 1
./js2hid /dev/input/js1 /dev/hidg1 &
