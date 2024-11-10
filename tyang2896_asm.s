@ Test code for my own new function called from C

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

    .global tyang2896_lab6        @ Make the symbol name for the function visible to the linker

    .code   16              @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func             @ Specifies that the following symbol is the name of a THUMB
                            @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type   tyang2896_lab6, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : int tyang2896_lab6(int delay)
@
@ Input: r0 (r0 holds delay from user)
@ 
@ Returns: r0
@ 

@ Here is the actual tyang2896_lab6 function
tyang2896_lab6:
    push {lr, r4 - r6}
    
    .equ index,   7       @ Set loop index to 7
    .equ counter, 0       @ Set toggle counter to 0
    mov r4, #index
    mov r5, #counter
    mov r6, r0
    loop:
        cmp r4, #0
        bge skip           @ Check the loop index
    reset:
        mov r4, index      @ Reset it to 7. Else, 
    skip:                  @ skip to next step
        @ Toggle the led at the current loop index
        mov r0, r4
        bl BSP_LED_Toggle  
        
        add r5, r5, #1     @ Increment the toggle counter
        subs r4, r4, #1    @ Decrement the loop index.
    
        @ Delay for variable amount of time, retrieved from the user in the C code
        mov r0, r6
        bl busy_delay      
        
        @ Check the state of the button using BSP_PB_GetState
        mov r0, #0
        bl BSP_PB_GetState 

        cmp r0, #1          @ If it is pressed,
        beq out            @ jump out of the loop.
        b loop             @ Else, go back to loop
    out:
    mov r0, r5             @ Return the toggle counter

    pop {lr, r4 - r6}
    bx lr                           @ Return (Branch eXchange) to the address in the link register (lr) 
    .size   tyang2896_lab6, .-tyang2896_lab6    @@ - symbol size (not strictly required, but makes the debugger happy)

@@ Function Header Block

    .global tyang2896_lab7        @ Make the symbol name for the function visible to the linker
    .type   tyang2896_lab7, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : int tyang2896_lab7(int x, int y)
@
@ Input: r0, r1 (i.e. r0 holds x, r1 holds y)
@ Returns: r0
@ 

@ Here is the actual tyang2896_lab7 function
tyang2896_lab7:
    push {r0, lr}

    @ These lines just show that the code is working
    bl busy_delay

    @ Get the state of the user button here.
    @ Return the result to the calling C function

    pop {r0, lr}
    bx lr                           @ Return (Branch eXchange) to the address in the link register (lr) 
    .size   tyang2896_lab7, .-tyang2896_lab7    @@ - symbol size (not strictly required)

.global tyang2896_a3
.type   tyang2896_a3, %function

@ Function Declaration: int tyang2896_a3(int delay, char *ptr, int number)
@
@ Input: r0, r1, r2 (i.e. r0 is the delay of toggle, r1 is a pointer to a char
@ r2 is the number of repeats)
@ Returns: r0 the number of times toggle has been called
@ 

@ Here is the function
tyang2896_a3:
    push {lr, r4 - r8}

    .equ ascii_0, 48                @ '0'
    .equ mod_8,    7                @ 2^3 - 1

    mov r4, r0                      @ delay
    mov r5, r1                      @ pattern pointer
    mov r6, r2                      @ number
    mov r7, #0                      @ counter
    repeat:
        subs r6, r6, #1             @ if(--number < 0)
        blt end                     @ Repeat time exceed number
        
        iterate:
            mov r0, #0
            bl BSP_PB_GetState      @ Get button state
            cmp r0, #1              @ If pressed
            beq end

            ldrb r8, [r5]           @ ASCII of *r5
            cmp r8, #0              @ if(ASCII == 0)
            beq terminate           @ Meet the string terminator
            
            sub r8, r8, #ascii_0    @ Convert ASCII to number
            and r8, r8, #mod_8      @ modulo for 8 which is power of 2

            mov r0, r8
            bl BSP_LED_Toggle       @ Toggle by pattern
            add r7, r7, #1          @ Increase the toggle counter
            
            mov r0, r4
            bl busy_delay           @ Delay by user specified
            add r5, r5, #1          @ Point to the next ASCII
            b iterate
        terminate:
        b repeat
    end:
    mov r0, r7

    pop {lr, r4 - r8}
    bx lr
    .size   tyang2896_a3, .-tyang2896_a3

@ Function Declaration: int busy_delay(int cycles)
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


@ Assembly file ended by single .end directive on its own line
.end

Things past the end directive are not processed, as you can see here.
