
.section .data
.section .text

.globl _start
.section .data

data_items:
  # A long is two words, so four bytes
  .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

.section .text

.globl _start

_start:
  movl $3, %esi # first arg -- power
  movl $2, %edi # second arg -- base
  call power
  # Save the return val before continuing
  pushl %eax
  movl $2, %esi
  movl $5, %edi
  call power
  # second answer is now in eax
  popl %ebx # pop the first answer to ebx
  addl %eax, %ebx
  movl $1, %eax
  int $0x80 # syscall

power:
  pushl %ebp # save the old base pointer
  movl %esp, %ebp # move the stack pointer to the base pointer. now ebp == esp
  # current result will go in ebx
  # subl $4, %esp # make room for our local storatge. now esp=ebp+4 or esp-4=ebp
  # our local storage will contain the current result value
  movl %edi, %eax

power_loop:
  cmpl $1, %esi # compare power to 1
  je power_loop_end # if power is 1, we're done
  imull %edi, %eax # multiply the result by the base
  decl %esi # decrement the power
  jmp power_loop

power_loop_end:
  movl %ebp, %esp # restore the stack pointer
  popl %ebp # restore the base pointer
  ret
