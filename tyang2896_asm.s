@ Assembly File - Lab 8 Version
@
@ NOTE THERE IS A DATA SECTION AT THE END OF THIS FILE FOR ASSIGNMENT 4
@ USE THAT DATA SECTION FOR ANY DATA YOU NEED, DO NOT ADD ANOTHER.

@ This is a comment. Anything after an @ symbol is ignored.
@@ This is also a comment. Some people use double @@ symbols. 


    .code   16              @ This directive selects the instruction set being generated. 
                            @ The value 16 selects Thumb, with the value 32 selecting ARM.

    .text                   @ Tell the assembler that the upcoming section is to be considered
                            @ assembly language instructions - Code section (text -> ROM)

@@ Function Header Block
    .align  2               @ Code alignment - 2^n alignment (n=2)
                            @ This causes the assembler to use 4 byte alignment

    .syntax unified         @ Sets the instruction set to the new unified ARM + THUMB
                            @ instructions. The default is divided (separate instruction sets)

    .global tyang2896_lab8        @ Make the symbol name for the function visible to the linker

    .code   16              @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func             @ Specifies that the following symbol is the name of a THUMB
                            @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type   tyang2896_lab8, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : void tyang2896_lab8(void)
@
@ Input: none
@ Returns: nothing
@ 

@ Here is the actual tyang2896_lab8 function
tyang2896_lab8:
    push {lr}

    @ For now, this function just toggles, delays, and toggles again.
    mov r0, #3
    bl BSP_LED_Toggle

    ldr r0, =0xFFFFFFF
    bl busy_delay

    mov r0, #3
    bl BSP_LED_Toggle

    pop {lr}
    bx lr                           @ Return (Branch eXchange) to the address in the link register (lr) 
    .size   tyang2896_lab8, .-tyang2896_lab8    @@ - symbol size (not strictly required, but makes the debugger happy)

@@ Function Header Block

    .global tyang2896_lab9        @ Make the symbol name for the function visible to the linker
    .type   tyang2896_lab9, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : int tyang2896_lab9(void)
@
@ Input: None
@ Returns: r0
@ 

@ Here is the actual tyang2896_lab9 function
tyang2896_lab9:
    push {lr}

    @ This is the assembly code to directly turn on an LED

    @ This code turns on only one light – can you make it turn them all on at once?
    ldr r1, =LEDaddress	@ Load the GPIO address we need
    ldr r1, [r1]		@ Dereference r1 to get the value we want
    ldrh r0, [r1]		@ Get the current state of that GPIO (half word only)

    eor r0, r0, #0xAA00		@ Use bitwise XOR (EOR) to toggle the bit at 0xAA00 = 0x0200 | 0x0800 | 0x2000 | 0x8000
    strh r0, [r1]		@ Write the half word back to the memory address for the GPIO

    LEDaddress:
        .word 0x48001014

    pop {lr}
    bx lr                           @ Return (Branch eXchange) to the address in the link register (lr) 
    .size   tyang2896_lab9, .-tyang2896_lab9    @@ - symbol size (not strictly required)


.global tyang2896_a4
.type   tyang2896_a4, %function

@ Function Declaration : int tyang2896_a4(int status, int num2skip, int direction)
@
@ Input: r0 holds status, r1 determines how many calls of tick will be skip,
@ r2 holds the direction of LEDs blink. 
@ Returns: Nothing
@ 

@ Here is the actual function
tyang2896_a4:
    push {lr, r4}
    @ This function only exists to start / initialize your A4
    @ logic working. No actions should be taken in this logic,
    @ aside from storing the parameters your A4 logic needs to run.

    @ Store the value we received indicating the running state
    ldr r3, =a4_is_running
    str r0, [r3]

    @ Store the value we received indicating the number of calls of tick to be skipped
    ldr r3, =a4_num_to_skip
    str r1, [r3]

    @ Reset number of skipped to zero
    ldr r3, =a4_num_of_skipped
    mov r1, #0
    str r1, [r3]

    @ Store the value we received indicating the direction of LEDs blink
    ldr r3, =a4_direction
    str r2, [r3]

    @ Reset current LED index to zero
    ldr r3, =a4_current_LED
    mov r2, #0
    str r2, [r3]

    mov r4, #7                 @ Set the max LED index
    loop:
        mov r0, r4             @ Set LED index to r0
        bl BSP_LED_Off         @ Turn off LED
        subs r4, r4, #1        @ index--
        bge loop               @ if(index >= 0) continue
    end:

    pop {lr, r4}
    bx lr
    .size   tyang2896_a4, .-tyang2896_a4

.global tyang2896_a5
.type   tyang2896_a5, %function

@ Function Declaration : int tyang2896_a5(int status, int num2skip, int direction)
@
@ Input: r0 holds status, r1 determines how many calls of tick will be skip,
@ r2 holds the direction of LEDs blink. 
@ Returns: Nothing
@ 

@ Here is the actual function
tyang2896_a5:
    push {lr, r4}
    @ This function only exists to start / initialize your A5
    @ logic working. No actions should be taken in this logic,
    @ aside from storing the parameters your A5 logic needs to run.

    @ Store the value we received indicating the running state
    ldr r3, =a5_running
    str r0, [r3]

    @ Store the value we received indicating the number of calls of tick to be skipped
    ldr r3, =a4_num_to_skip
    str r1, [r3]

    @ Reset number of skipped to zero
    ldr r3, =a4_num_of_skipped
    mov r1, #0
    str r1, [r3]

    @ Store the value we received indicating the direction of LEDs blink
    ldr r3, =a4_direction
    str r2, [r3]

    @ Reset current LED index to zero
    ldr r3, =a4_current_LED
    mov r2, #0
    str r2, [r3]

    mov r4, #7                 @ Set the max LED index
    loop_led:
        mov r0, r4             @ Set LED index to r0
        bl BSP_LED_Off         @ Turn off LED
        subs r4, r4, #1        @ index--
        bge loop_led           @ if(index >= 0) continue
    end_led:

    @ Initialize the watchdog with 8000 reload value then start
    mov r0, #8000
    bl mes_InitIWDG
    bl mes_IWDGStart
    ldr r3, =a5_IWDG_initialized
    mov r0, #1
    str r0, [r3]

    pop {lr, r4}
    bx lr
    .size   tyang2896_a5, .-tyang2896_a5

.global tyang2896_a4_btn
.type   tyang2896_a4_btn, %function

@ Function Declaration : void tyang2896_a4_btn(void)
@
@ Input: None
@ Returns: Nothing
@ 
@ Reminder - this requires the button has been initialized as an interrupt
@ in main.c using BSP_PB_Init(BUTTON_USER, BUTTON_MODE_EXTI)
@ as well as requires a new function set up void EXTI0_IRQHandler(void)

@ Here is the actual function
tyang2896_a4_btn:
    push {lr}

    ldr r1, =a4_button_count        @ Get the address of the counter
    ldr r0, [r1]                    @ Get the actual count
    add r0, r0, #1                  @ Increment the count
    and r0, #7                      @ Keep the count between 0 and 7
    str r0, [r1]                    @ Store the new count

    bl BSP_LED_Toggle               @ Toggle the current LED

    pop {lr}
    bx lr
    .size   tyang2896_a4_btn, .-tyang2896_a4_btn

.global tyang2896_a5_btn
.type   tyang2896_a5_btn, %function

@ Function Declaration : void tyang2896_a5_btn(void)
@
@ Input: None
@ Returns: Nothing
@ 
@ Reminder - this requires the button has been initialized as an interrupt
@ in main.c using BSP_PB_Init(BUTTON_USER, BUTTON_MODE_EXTI)
@ as well as requires a new function set up void EXTI0_IRQHandler(void)

@ Here is the actual function
tyang2896_a5_btn:

    ldr r1, =a5_btn_pressed        @ Get the address of the button status
    mov r0, #1
    str r0, [r1]                   @ Store the pressed status

    bx lr
    .size   tyang2896_a5_btn, .-tyang2896_a5_btn

.global tyang2896_a4_tick
.type   tyang2896_a4_tick, %function

@ Function Declaration : void tyang2896_a4_tick(void)
@
@ Input: None
@ Returns: Nothing
@ 

@ Here is the actual function
tyang2896_a4_tick:
    push {lr}

    @ As a starting point, this function implements the basics needed
    @ to determine if our A4 logic should be running.
    @
    @ You will have to add logic here for A4.

    @ Some useful notes
    @
    @ BSP_LED_On, BSP_LED_Off - same argument as BSP_LED_Toggle, sets
    @ the LED to ON or OFF as you tell it
    @
    @ How to delay: DO NOT use busy_delay - remember, this is an interrupt
    @ handler. If you need a delay, use a counter to count how many times
    @ this function has been called, and use that to skip a desired number
    @ of calls.


    @ ***** Get status
    ldr r1, =a4_is_running
    ldr r0, [r1]

    @ ***** Check status
    cmp r0, #0
    ble a4_skip

        @ This part below is skipped if A4 is NOT running. You will want to
        @ keep all your A4 logic inside here.
        @ DO NOT PUT LOGIC FOR A4 ABOVE THIS LINE -----------------------------

        @ Even within this logic, you should still take a philosopy of check
        @ things, do things, and store things - do not use delays of any sort,
        @ and only use loops if they are bounded (that is, guaranteed to end)
        
        @ ***** Get the number to skip
        ldr r1, =a4_num_to_skip
        ldr r0, [r1]
        @ ***** Get the number of skipped
        ldr r3, =a4_num_of_skipped
        ldr r2, [r3]
        @ ***** compare the number of skipped with total
        cmp r2, r0
        @ num2skip++
        add r2, r2, #1
        str r2, [r3]
        blt a4_skip

            @ reset number of skipped
            mov r0, #0
            str r0, [r3]            
                
            @ load current LED index
            ldr r1, =a4_current_LED
            ldr r0, [r1]
            bl BSP_LED_Toggle

            @ load direction
            ldr r3, =a4_direction
            ldr r2, [r3]
            @ load current LED index
            ldr r1, =a4_current_LED
            ldr r0, [r1]
            add r0, r0, r2              @ index = index + direcion
            and r0, #7                  @ MOD 8
            str r0, [r1]                @ store curent LED index

        @ DO NOT PUT LOGIC FOR A4 BELOW THIS LINE -----------------------------
        @ End of A4 skipped logic. Do not add logic below here.

    a4_skip:

    @ ***** End of our tick function
    pop {lr}
    bx lr
    .size   tyang2896_a4_tick, .-tyang2896_a4_tick

.global tyang2896_a5_tick
.type   tyang2896_a5_tick, %function

@ Function Declaration : void tyang2896_a5_tick(void)
@
@ Input: None
@ Returns: Nothing
@ 

@ Here is the actual function
tyang2896_a5_tick:
    push {lr}

    @ As a starting point, this function implements the basics needed
    @ to determine if our A5 logic should run or not.
    @
    @ You will have to add logic here for A5.

    @ Some useful notes
    @
    @ DO NOT REFRESH THE WATCHDOG WITH mes_IWDGRefresh UNLESS IT
    @ HAS PREVIOUSLY BEEN STARTED OR YOUR BOARD WILL CRASH
    @ Get watchdog status.
    ldr r1, =a5_IWDG_initialized
    ldr r0, [r1] 
    @ Refresh when it initialized
    cmp r0, #1
    blt skip_refresh
        @ Get button status.
        ldr r1, =a5_btn_pressed
        ldr r0, [r1]
        @ Stop refresh when the button pressed.
        cmp r0, #1
        beq skip_refresh
            bl mes_IWDGRefresh
    skip_refresh:
    

    @ ***** Get something
    ldr r1, =a5_running
    ldr r0, [r1]

    @ ***** Check something
    cmp r0, #0
    ble a5_skip

        @ This part below is skipped if A5 is NOT running. You will want to
        @ keep all your A5 logic inside here.
        @ DO NOT PUT LOGIC FOR A5 ABOVE THIS LINE -----------------------------

        @ Even within this logic, you should still take a philosophy of check
        @ things, do things, and store things - do not use delays of any sort,
        @ and only use loops if they are bounded (that is, guaranteed to end)

        ldr r1, =LEDaddress	@ Load the GPIO address we need
        ldr r1, [r1]		@ Dereference r1 to get the value we want
        ldrh r0, [r1]		@ Get the current state of that GPIO (half word only)

        eor r0, r0, #0x5500		@ Use bitwise XOR (EOR) to toggle the bit at 0x5500 = 0x0100 | 0x0400 | 0x1000 | 0x4000
        strh r0, [r1]		@ Write the half word back to the memory address for the GPIO


        @ DO NOT PUT LOGIC FOR A5 BELOW THIS LINE -----------------------------
        @ End of A5 skipped logic. Do not add logic below here.

    a5_skip:

    @ ***** Exit
    pop {lr}
    bx lr
    .size   tyang2896_a5_tick, .-tyang2896_a5_tick

@ Function Declaration : int busy_delay(int cycles)
@
@ Input: r0 (i.e. r0 is how many cycles to delay)
@ Returns: r0
@ 

@ Here is the actual function. DO NOT MODIFY THIS FUNCTION
busy_delay:
    push {r6}
    mov r6, r0

    d3lay_loop:
        subs r6, r6, #1
        bge d3lay_loop

        mov r0, #0      @ Return zero (success)

    pop {r6}
    bx lr               @ Return to calling function


@ Here is another data section, we will use it for some key interrupt items
@ We will put all necessary data for A4 in this block
.data
a4_is_running: .word 0
a4_num_to_skip: .word 0
a4_num_of_skipped: .word 0
a4_direction: .word 0
a4_current_LED: .word 0
a4_button_count: .word 0

a5_running: .word 0
a5_IWDG_initialized: .word 0
a5_btn_pressed: .word 0

@ Assembly file ended by single .end directive on its own line
.end

Things past the end directive are not processed, as you can see here.
