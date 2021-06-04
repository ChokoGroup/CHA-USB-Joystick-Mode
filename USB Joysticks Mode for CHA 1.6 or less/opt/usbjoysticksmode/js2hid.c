#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/input.h>

int main(int argc, char* argv[]) {
  if (argc < 3) {
    printf("Usage: %s joystick_input hid_output\nExample: %s /dev/input/event2 /dev/hidg0\n", argv[0], argv[0]);
  }
  else {
    int joy_fd;
    if ( ( joy_fd = open( argv[1] , O_RDONLY|O_NONBLOCK)) == -1 ) {
      printf("Couldn't open %s\nUsage: %s joystick_input hid_output\nExample: %s /dev/input/event2 /dev/hidg0\n", argv[1], argv[0], argv[0]);
      return -1;
    }
/*
      char device_name[64];
      ioctl(joy_fd, EVIOCGNAME(sizeof device_name - 1), device_name);
      printf("Joystick is named '%s'.\n", device_name);
*/

    FILE * hid_fd;
    if ((access(argv[2], W_OK) == 0) && ((hid_fd = fopen(argv[2], "a")) == NULL)) {
      printf("Couldn't open %s\nUsage: %s joystick_input hid_output\nExample: %s /dev/input/event2 /dev/hidg0\n", argv[2], argv[0], argv[0]);
      return -1;
    }

    struct input_event event;
    char *axis = (char *) calloc( 2, sizeof( char ) );
    axis[0] = 127; axis[1] = 127;
    unsigned char buttons = 0;
    while (1) {
      if (read(joy_fd, &event, sizeof(struct input_event)) > 0) {
        switch (event.type) {
/*
          Event type 3 (EV_ABS)
          Event code 1 (ABS_Y)
          Event code 0 (ABS_X)
                value    127
                Min        0
                Max      255
                Flat      15
*/
          case 3:
            axis[event.code] = event.value;
          break;
/*
          Event type 1 (EV_KEY)
          Event code 288 (BTN_TRIGGER)
          Event code 289 (BTN_THUMB)
          Event code 290 (BTN_THUMB2)
          Event code 291 (BTN_TOP)
          Event code 292 (BTN_TOP2)
          Event code 293 (BTN_PINKIE)
          Event code 294 (BTN_BASE)
          Event code 295 (BTN_BASE2)
                value   0 or 1
*/
          case 1:
            if (event.value == 1) {
              buttons = buttons | (1 << (event.code % 8));
            } else {
              buttons = buttons & ~(1 << (event.code % 8));
            }
  
          break;
        }
        if (axis[0] == 0) {           /* X = left */
          if (axis[1] == 0) {           /* Y = up */
            fputc(0x0a, hid_fd);
          } else if (axis[1] == 255) {  /* Y = down */
            fputc(0x06, hid_fd);
          } else {                      /* Y = center */
            fputc(0x02, hid_fd);
          }
        } else if (axis[0] == 255) {  /* X = right */
          if (axis[1] == 0) {           /* Y = up */
            fputc(0x09, hid_fd);
          } else if (axis[1] == 255) {  /* Y = down */
            fputc(0x05, hid_fd);
          } else {                      /* Y = center */
            fputc(0x01, hid_fd);
          }
        } else {                      /* X = center */
          if (axis[1] == 0) {           /* Y = up */
            fputc(0x08, hid_fd);
          } else if (axis[1] == 255) {  /* Y = down */
            fputc(0x04, hid_fd);
          } else {                      /* Y = center */
            fputc(0x00, hid_fd);
          }
        }
        fputc(buttons, hid_fd);
        fflush(hid_fd);
      }
    }
    /* this will never happen */
    fclose( hid_fd );
    close( joy_fd );
  }
	return 0;
}
