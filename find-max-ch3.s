.section .data

data_items:
  .long 3,67,34,222,45,75,54,34,44,33,22,11,66,0

.section .text

.globl _start

_start:
  movl $0, %edi
  # Get the address of data_items + (edi * 4)
  # edi is the index while 4 is the multiplier (each elem is 1 long/4 bytes)
  movl $data_items, %esi
  call add1
  movl $1, %eax # exit
  # The max is in ebx and will return as the status code
  int $0x80 # syscall

add1:
  cmpl $0, %eax # check if we have reached the end of list (0)
  je loop_exit
  incl %edi # increment the index
  movl data_items(,%edi,4), %eax # load the next value to eax
  cmpl %ebx, %eax
  jle start_loop # if the current val is less than max, then skip
  movl %eax, %ebx # otherwise, set the max
  jmp start_loop # iterate

add1_loop:
