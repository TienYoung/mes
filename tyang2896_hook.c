/*
 *	C to assembler menu hook
 * 
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

int tyang2896_add_test(int x, int y, int delay);
int tyang2896_a2(int num, int wait);

void AddTest(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Addition Test\n\n"
	   "This command tests new addition function by tyang2896\n"
	   );

    return;
  }
  uint32_t delay;

  int fetch_status;

  fetch_status = fetch_uint32_arg(&delay);

  if(fetch_status) {
  	// Use a default delay value
  	delay = 0xFFFFFF;
  }

  // When we call our function, pass the delay value.
  // printf(“<<< here is where we call add_test – can you add a third parameter? >>>”);

  printf("tyang2896_add_test returned: %d\n", tyang2896_add_test(99, 87, delay) );
}

ADD_CMD("tyang2896_add", AddTest,"Test the new add function")

// Assignment 2 C Hook Function
//
void _tyang2896_Assignment2(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Assignment 2\n\n"
	   "This command triggers assignment 2 by tyang2896\n"
	   );

    return;
  }

  // Retrieve user inputs for count and delay here
  uint32_t count;
  uint32_t delay;
  int fetch_status;

  fetch_status = fetch_uint32_arg(&count);

  if(fetch_status) {
  	// Use a default value
  	count = 0xFFFFEF;
  }

  fetch_status = fetch_uint32_arg(&delay);

  if(fetch_status) {
  	// Use a default value
  	delay = 0xFFFFEF;
  }

  printf("tyang2896_a2 returned: %d\n", tyang2896_a2(count, delay));
}

ADD_CMD("tyang2896_a2", _tyang2896_Assignment2, "Assignment 2")
