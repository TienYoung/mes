/*
 *  C to assembler menu hook
 *
 *  Modified by tyang2896
 * 
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

/*
* Function Name: tyang2896_lab6
* Parameter: 
*   delay: interval of toggle leds
* Return: count of the leds toggled
*/
int tyang2896_lab6(int delay);

void Lab6_tyang2896(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Lab 6\n\n"
	   "This command tests new lab 6 function by tyang2896\n"
	   );

    return;
  }
  uint32_t delay = 0;

  // Get deley from user
  int fetch_status = fetch_uint32_arg(&delay);

  if(fetch_status) {
  	// Use a default delay value
  	delay = 0xFFFFFF;
  }

  printf("tyang2896_lab6 returned: %d\n", tyang2896_lab6(delay) );
}

ADD_CMD("tyang2896_lab6", Lab6_tyang2896,"Test the new lab 6 function")

int tyang2896_a3(char *p);

void A3_tyang2896(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Assignment 3 Test\n\n"
	   "This command tests new A3 function by tyang2896\n"
	   );

    return;
  }

  int fetch_status;
  char *pattern;

  fetch_status = fetch_string_arg(&pattern);

  if (fetch_status) {
    // Default logic goes here
    pattern = "Test Pattern";
  }

  printf("tyang2896_a3 returned: %d\n", tyang2896_a3(pattern) );
}

ADD_CMD("tyang2896_a3", A3_tyang2896,"Test the A3 function")
