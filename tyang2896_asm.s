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
