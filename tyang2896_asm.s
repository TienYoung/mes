@ Test code for my own new function called from C

@ This is a comment. Anything after an @ symbol is ignored.
@@ This is also a comment. Some people use double @@ symbols. 

@ tyang2896_asm.s Data section - initialized values
    .data

    .align 3    @ This alignment is critical - to access our "huge" value, it must
                @ be 64 bit aligned

    huge:   .octa 0xAABBCCDDDDCCBBFF
    big:    .word 0xAAEEBBFF
    num:    .byte 0xAB


    str2:   .asciz "Guten Tag!"
    count:  .word 12345                     @ This is an initialized 32 bit value

@ End of new data section

    .code   16              @ This directive selects the instruction set being generated. 
                            @ The value 16 selects Thumb, with the value 32 selecting ARM.

    .text                   @ Tell the assembler that the upcoming section is to be considered
                            @ assembly language instructions - Code section (text -> ROM)

@@ Function Header Block
    .align  2               @ Code alignment - 2^n alignment (n=2)
                            @ This causes the assembler to use 4 byte alignment

    .syntax unified         @ Sets the instruction set to the new unified ARM + THUMB
                            @ instructions. The default is divided (separate instruction sets)

    .global tyang2896_add_test        @ Make the symbol name for the function visible to the linker

    .code   16              @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func             @ Specifies that the following symbol is the name of a THUMB
                            @ encoded function. Necessary for interlinking between ARM and THUMB code.

    .type   tyang2896_add_test, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : int tyang2896_add_test (int x, int y)
@
@ Input: r0, r1 (i.e. r0 holds x, r1 holds y)
@ Returns: r0
@ 

@ Here is the actual tyang2896_add_test function
tyang2896_add_test:
    @ Load the addresses of each of our items
    ldr r0, =num
    ldr r0, =big
    ldr r0, =huge
    ldr r0, =str2

    ldr r2, =str2			@ Load the address of str2 and store it in r2
    ldrb r0, [r2]			@ Load the value stored at the address str2 as a byte

    ldr r2, =str2			@ Load the address of str2 and store it in r2
    ldr r0, [r2]			@ Load the value stored at the address str2 as a word

    ldr r2, =num			@ Load the address of num and store it in r2
    ldrb r0, [r2]			@ Load the value stored at the address num

    ldr r2, =big			@ Load the address of big
    ldr r0, [r2]			@ Load the value of big

    ldr r2, =huge			@ Load the address of huge
    ldrd r0, r1, [r2]		@ Load the value of huge

    add r0, r0, r1

    push {lr, r0}

    mov r0, r2

    bl busy_delay

    pop {lr, r0}

    bx lr                           @ Return (Branch eXchange) to the address in the link register (lr) 

    .size   tyang2896_add_test, .- tyang2896_add_test @@ - symbol size (makes the debugger happy)

@@ Function Header Block
    .align  2               @ Code alignment is 2^n alignment (n=2)
    .syntax unified         @ Sets the instruction set to the unified ARM + THUMB
    .global tyang2896_a2   @ Make the symbol name for the function visible to the linker
    .code   16              @ 16bit THUMB code (BOTH .code and .thumb_func are required)
    .thumb_func             @ Specifies that the following symbol is the name of a THUMB
    .type   tyang2896_a2, %function   @ Declares that the symbol is a function (not strictly required)

@ Function Declaration : int tyang2896_a2 (int num, int wait)
@
@ Input: Document This
@ Returns: Document This
@ 

@ Here is the assignment 2 assembly function
tyang2896_a2:

    @ Fill in the necessary logic here
    push {r4}                    @ Preserve r4 for caller.
    mov r4, r0                   @ Use r4 as loop indicator.
    loop:
        subs r4, r4, #1          @ r4--;
        bmi out                  @ r4 < 0 ? break : continue;
        @ Toggle all leds
        push {r5}                @ Preserve r5 for caller.
        mov r5, #0               @ r5 = 0;
        toggle_beg:
            push {lr, r0 - r1}      @ Preseve lr, r0 - r1 for subroutine.
            mov r0, r5              @ r0 = r5;
            bl BSP_LED_Toggle
            pop {lr, r0 - r1}       @ Restore lr, r0 - r1.
            
            add r5, r5, #1          @ r5++;
            cmp r5, #8              @ r5 < 8 : continue ? break;
            blt toggle_beg
        toggle_end:
        pop {r5}                  @ Restore r5.

        @ Delay to the next
        push {lr, r0}             @ Preserve lr, r0 for subroutine.
        mov r0, r1                @ r0 = r1;
        bl busy_delay
        pop {lr, r0}              @ Restore lr, r0.

        b loop                    @ Repeat.
    out:
    pop {r4}                      @ Restore r4.

    bx lr                           @ Return (Branch eXchange) to the address held by the lr 

    .size   tyang2896_a2, .- tyang2896_a2    @@ - symbol size (makes the debugger happy)

.global tyang2896_string_test

@ Function Declaration : int tyang2896_string_test(char *p)
@
@ Input: r0 (i.e. r0 a pointer to a byte array)
@ Returns: r0
@ 

@ Here is the actual function
tyang2896_string_test:
    StringLoop:
        ldrb r1, [r0]                    @ Dereference the character r0 points to
        
        cmp r1, #0                       @ Check if that value is zero
        
        beq OutLabel                     @ if it is, branch out

        add r0, r0, #1                   @ Add one to R0
        
        b StringLoop                     @ Branch back to string loop

    OutLabel:

    bx lr
    .size   tyang2896_string_test, .-tyang2896_string_test


@ Function Declaration : int busy_delay(int cycles)
@
@ Input: r0 (i.e. r0 holds number of cycles to delay)
@ Returns: r0
@ 

@ Here is the actual function. DO NOT MODIFY THIS FUNCTION.
busy_delay:

    push {r6}

    mov r6, r0

delay_label:
    subs r6, r6, #1

    bge delay_label

    mov r0, #0                      @ Always return zero (success)

    pop {r6}

    bx lr                           @ Return (Branch eXchange) to the address in the link register (lr)

@ Assembly file ended by single .end directive on its own line
.end
