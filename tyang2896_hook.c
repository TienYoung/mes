/*
 *  C to assembler menu hook - Lab 8 Version
 *
 *  Modified by tyang2896
 * 
 */

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "stm32f3_discovery_gyroscope.h"

#include "common.h"

#define N 500

// A4 Interrupt Handlers - these are in tyang2896_asm.s
void tyang2896_a4_btn(void);
void tyang2896_a4_tick(void);


// Timer tick hook for our timer interrupt
// driven programming.
//
// Note that for now, this function toggles LED 0 every N cycles.
void tyang2896_tick(void)
{
  // Our tick variable is static so that it keeps its value from one
  // function call to the next.
  //
  // If this was not static, this would not work because ticks would
  // get reinitialized every time the function was called.
  static int32_t ticks;
  
  // Increment our tick count every time the timer interrupt fires.
  // Can you measure approximately how fast the tick is running? Try
  // timing how long it takes for the LED to blink 10 times.
  ticks++;

  // Every time we reach N cycles, reset the tick count to zero
  // and toggle LED 0.
  //
  // This proves to us that our interrupt is working.
  if (ticks > N)
  {
    ticks = 0;
    tyang2896_a4_tick();
  }


}

// Button press hook for our button interrupt
// driven programming.
//
// Note that for now, this function toggles LED 6 when the button is pressed.
void tyang2896_btn(void)
{
  // For now, just toggle an LED to prove the button press was noticed.
  tyang2896_a4_btn();
}

int tyang2896_lab8(void);

void Lab8_tyang2896(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Lab 8\n\n"
	   "This command tests new lab 8 function by tyang2896\n"
	   );

    return;
  }


  printf("tyang2896_lab8 returned: %d\n", tyang2896_lab8() );
}

ADD_CMD("tyang2896_lab8", Lab8_tyang2896,"Test the new lab 8 function")

/*
* Function Name: tyang2896_lab9
* Purpose: This function is toggle LED 0
* Return: none
*/
int tyang2896_lab9(void);

void Lab9_tyang2896(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Lab 9\n\n"
	   "This command tests new lab 9 function by tyang2896\n"
	   );

    return;
  }

  printf("tyang2896_lab9 returned: %d\n", tyang2896_lab9() );

  
}

ADD_CMD("tyang2896_lab9", Lab9_tyang2896,"Test the new lab 9 function")

int tyang2896_a4(int status, int num2skip, int direction);

void A4_tyang2896(int action)
{

  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP) {
    printf("Assignment 4 Test\n\n"
	   "This command tests new A4 function by tyang2896\n"
	   );

    return;
  }

  int fetch_status;
  uint32_t status;
  uint32_t num2skip;
  uint32_t direction;

  fetch_status = fetch_uint32_arg(&status);
  if (fetch_status) {
    status = 1;
  }
  fetch_status = fetch_uint32_arg(&num2skip);
  if (fetch_status) {
    num2skip = 1;
  }
  fetch_status = fetch_uint32_arg(&direction);
  if (fetch_status) {
    direction = 1;
  }

  printf("tyang2896_a4 returned: %d\n", tyang2896_a4(status, num2skip, direction));
}

ADD_CMD("tyang2896_a4", A4_tyang2896,"Test the A4 function")


