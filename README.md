# CHA USB-Joystick-Mode
Use the CHA as 2 USB joysticks.
Tested on CHA firmware 1.6 with Windows PC, Linux PC, Android tablet, Android TV and PS3.
* This feature will be included in 1.7 official firmware! Cheers to Koch Media and CHA developers. *
* Choko Hack v12.3.0 supports official USB Joystick Mode in firmware 1.7+. *
* This pack is now considered obsolete and no longer supported. *

### Thanks to JJ_0 for the discovery!
CHOKO HACK v12 REQUIRED

1. Extract and copy the folder 'USB Joysticks Mode for CHA 1.6 or less' to the root of USB pendrive.
2. Insert the pendrive in CHA USB EXT and power on.
3. If a menu shows up, select: Install menu option: "Activate USB Joysticks Mode".

Now you'll see a menu at startup with one (new) option to activate the USB Joystick Mode.

When USB Joystick mode is selected, the CHA immediately reboots and will always boot in Joystick Mode until you press [P1 START] and [P2 START] in the first 5 seconds after the button red light turns on.

We can power up the CHA using only an USB-A to USB-A cable from the CHA USB port to your PC or we can power up the CHA as usual and then connect the USB-A to USB-A cable from CHA to PC.


### Buttons Configuration
The CHA is detected as one device with two independent "game pads", each with one joystick and 8 buttons.

In Android devices, the layout detected is:
```
             R1 L1  <- this is not a typo

   ( J )   A  B  C
           X  Y  Z
```

In Windows 10, the layout detected is:
```
              8  7  <- this is not a typo

   ( J )   1  2  3
           4  5  6
```

Because each game has its own way to handle the buttons, many are playable with the CHA, many don't.
With front-ends where we can remap the buttons, like RetroArch, MAME, Steam or Epig Games, this problem a minimized. Still, some games won't work.
Compatibility with PlayStation 3 games is very low (works with Mortal Kombat) and probably not better with PS4.

### Notes
- In RetroArch, the first time you use the CHA as joysticks you must remap D-PAD UP, DOWN, LEFT and RIGHT, as well as all the buttons, SELECT and START in particular.
- In Steam, some games (like Tekken) require that you define a button to make the joystick behave as d-pad in order to navigate the menus.
- "Safe Shutdown" and "Safe Reboot" buttons combos still work in USB Joystick Mode.
