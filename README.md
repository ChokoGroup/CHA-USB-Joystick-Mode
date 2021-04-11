# CHA USB-Joystick-Mode
Use the CHA as 2 USB joysticks.
Tested on CHA firmware 1.6 with Windows PC, Linux PC, Android tablet, Android TV and PS3.


### Thanks to JJ_0 for the discovery!
CHOKO HACK v11 REQUIRED

1. Extract and copy the folder "Choko Hack v11 Joystick Mode" to the root of USB pendrive.
2. Insert the pendrive in CHA USB EXT and power on.
3. If you had more options, select "Choko Hack v11 Joystick Mode" in the Choko Menu.
4. Select if you want to use [P2 Insert] or [P2 Start] to enable USB Joystick Mode (pressing [P1 A] or [P1 B] in this installer menu).
   If you prefer the alternative mapping, with X Y Z in top row, press either [P1 C] or [P1 D] to add the menu option to [P2 Insert] or [P2 Start].

If there wasn't Lakka or any games lists installed, now you'll see a menu at startup.
The startup menu has one (new) option to change into USB Joystick Mode.

When USB Joystick mode is selected, the CHA immediately reboots and will always boot in Joystick Mode until you press [P2 Insert] or [P2 Start] (the one you selected to install) in the first 5 seconds after the button red light turns on.

We can power up the CHA using only an USB-A to USB-A cable from the CHA USB port to your PC or we can power up the CHA as usual and then connect the USB-A to USB-A cable from CHA to PC.


### Buttons Configuration
The CHA is detected as one device with two independent "game pads", each with one joystick and 8 buttons.
The default layout is:
```
             L1 R1

   ( J )   A  B  C
           X  Y  Z
```

Because each game has its own way to handle the buttons, many are playable with the CHA, many don't.
With front-ends where we can remap the buttons, like RetroArch, MAME, Steam or Epig Games, this problem a little minimized. Still, some games won't work.
In the very few PlayStation 3 games tested, CHA only worked with Mortal Kombat (it was the only fighting games tested).

### Notes
- In RetroArch, the first time you use the CHA as joysticks you must remap D-PAD UP, DOWN, LEFT and RIGHT, as well as all the buttons, SELECT and START in particular.
- In Steam, some games (like Tekken) require that you define a button to make the joystick behave as d-pad in order to navigate the menus.
- "Safe Shutdown" and "Safe Reboot" buttons combos still work in USB Joystick Mode.
