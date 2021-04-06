#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/joystick.h>

int main( int argc , char* argv[] )
{
  if(argc < 2)
  {
    printf("\nUsage: %s joystick_input hid_output",argv[0]);
    printf("\nExample: %s /dev/input/js0 /dev/hidg0\n",argv[0]);
  }
  else
  {
    int joy_fd, num_of_axis=0, num_of_buttons=0;
    char *axis=NULL;
    FILE * hid_fd;
    char *button=NULL, buttons=0, mask=0, name_of_joystick[80];
    struct js_event js;

    if( ( joy_fd = open( argv[1] , O_RDONLY)) == -1 )
    {
      printf( "Couldn't open joystick\n" );
      return -1;
    }

    if( ( hid_fd = fopen( argv[2] , "a")) == 0 )
    {
      printf( "Couldn't open hid\n" );
      return -1;
    }

    ioctl( joy_fd, JSIOCGAXES, &num_of_axis );
    ioctl( joy_fd, JSIOCGBUTTONS, &num_of_buttons );
    ioctl( joy_fd, JSIOCGNAME(80), &name_of_joystick );

    axis = (char *) calloc( num_of_axis, sizeof( char ) );
    button = (char *) calloc( num_of_buttons, sizeof( char ) );

    printf("\nJoystick detected: %s\n\t%d axis\n\t%d buttons\n\n", name_of_joystick, num_of_axis, num_of_buttons);

    fcntl( joy_fd, F_SETFL, O_NONBLOCK );	/* use non-blocking mode */

    while( 1 ) 	/* infinite loop */
    {
        /* read the joystick state */
      read(joy_fd, &js, sizeof(struct js_event));

        /* see what to do with the event */
      switch (js.type & ~JS_EVENT_INIT)
      {
        case JS_EVENT_AXIS:
          axis   [ js.number ] = js.value;
          break;
        case JS_EVENT_BUTTON:
          button [ js.number ] = js.value;
          mask = (255 - 1)<<js.number;
          buttons = (buttons & mask) | js.value<<js.number;
          break;
      }

      if (axis[0] == 1)  /* X = left */
      {
        if (axis[1] == 1)  /* Y = up */
        {
          fputc(0x0a, hid_fd);
        }
        else if (axis[1] == 255)  /* Y = down */
        {
          fputc(0x06, hid_fd);
        }
        else
        {
          fputc(0x02, hid_fd);
        }
      }
      else if (axis[0] == 255)  /* X = right */
      {
        if (axis[1] == 1)  /* Y = up */
        {
          fputc(0x09, hid_fd);
        }
        else if (axis[1] == 255)  /* Y = down */
        {
          fputc(0x05, hid_fd);
        }
        else
        {
          fputc(0x01, hid_fd);
        }
      }
      else
      {
        if (axis[1] == 1)
        {
          fputc(0x08, hid_fd);
        }
        else if (axis[1] == 255)
        {
          fputc(0x04, hid_fd);
        }
        else
        {
          fputc(0x00, hid_fd);
        }
      }
      fputc(buttons, hid_fd);
      fflush(hid_fd);
    }
    close( joy_fd );	/* this will never happen */
  }
	return 0;
}

