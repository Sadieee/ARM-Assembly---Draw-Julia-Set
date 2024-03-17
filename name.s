.data
start_name:  .asciz"*****Print Name*****\n"
end_name:    .asciz"*****End Print*****\n"
team:        .asciz"Team 50\n"
name1:       .asciz"Stephanie Hsiao\n"
name2:       .asciz"Sadie Fang\n"
name3:       .asciz"Peggy Liao\n"

        .text
        .globl team
        .globl name
        .globl name1
        .globl name2
        .globl name3
name:
        stmfd sp!,{lr}
        ldr   r0, = start_name
        bl    printf

@Printf Group & Name

@group
        ldr   r0, = team
        bl    printf

@name1
        ldr   r0, = name1
        bl    printf

@name2
        ldr   r0, = name2
        bl    printf

@name3
        ldr   r0, = name3
        bl    printf
        ldr   r0, = end_name
        bl    printf

        mov   r0, #0
        ldmfd sp!, {lr}
        @addeq r0, r1, r2, lsl #4
        @bic   r15, #8
        @adds  r15, r14, r13
        mov   pc, lr


