.data
end_id:     .asciz"*****End Print*****\n"
start_id:   .asciz"*****Input ID*****\n"
str1:       .asciz"**Please Enter Member 1 ID:**\n"
str2:       .asciz"**Please Enter Member 2 ID:**\n"
str3:       .asciz"**Please Enter Member 3 ID:**\n"
str4:       .asciz"*****Print Team Member ID and ID Summation*****\n"
str5:       .asciz"**Please Enter Command **\n"
n_line:     .asciz"\n"
num:        .asciz"%d"
print_all:  .asciz"%c"
print_sum:  .asciz"ID Summation = %d\n"
ID1:        .word 0
ID2:        .word 0
ID3:        .word 0
SUM:        .word 0
User:       .word 0

       .text
       .globl id
       .globl ID1
       .globl ID2
       .globl ID3
       .globl SUM
       .globl print_sum

id:
     stmfd sp!, {lr}
     ldr   r0, =start_id
     bl    printf

@Scanf ID

@id1
     ldr   r0, =str1
     bl    printf
     ldr   r0, =num
     ldr   r1, =ID1
     bl    scanf

@id2
     ldr   r0, =str2
     bl    printf
     ldr   r0, =num
     ldr   r1, =ID2
     bl    scanf

@id3
     ldr   r0, =str3
     bl    printf
     ldr   r0, =num
     ldr   r1, =ID3
     bl    scanf

@Scanf Command 'p'
     ldr   r0, =str5
     bl    printf

     ldr   r0, =print_all
     ldr   r1, =User
     bl    scanf
     ldr   r0, =User
     ldr   r0, [r0]

@Check If The Command Is The Same As 'p'
user_loop:

@Scanf User Command
          ldr  r0, =print_all
          ldr  r1, =User
          bl   scanf
          ldr  r0, =User
          ldr  r0, [r0]

@compare if scanf char == 'p'
          cmp  r0, #'p'

@if char != 'p', Go Back To Loop Test
          bne  user_loop

@Print ID & Summation
do_sum:

@id1
          ldr  r0, =str4
          bl   printf
          ldr  r0, =num
          ldr  r1, =ID1
          ldr  r1, [r1]
          bl   printf

          ldr  r0, =n_line
          bl   printf

@id2
          ldr  r0, =num
          ldr  r1, =ID2
          ldr  r1, [r1]
          bl   printf

          ldr  r0, =n_line
          bl   printf

@id3
          ldr  r0, =num
          ldr  r1, =ID3
          ldr  r1, [r1]
          bl   printf

          ldr  r0, =n_line
          bl   printf
          ldr  r0, =n_line
          bl   printf

@total
          ldr    r0, =print_sum
          ldr    r1, =ID1
          ldr    r1, [r1]
          ldr    r2, =ID2
          ldr    r2, [r2]
          addal    r1, r1, r2
          ldr    r3, =ID3
          ldr    r3, [r3]
          addhs    r1, r1, r3
          ldr    r4, =SUM
          str    r1, [r4], #4
          bl     printf

          ldr    r5, [r6, r7]

          ldr    r0, =end_id
          bl     printf

          mov    r0, #0
          ldmfd  sp!, {lr}
          mov    pc, lr








