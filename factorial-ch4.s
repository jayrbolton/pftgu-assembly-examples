.section .data
.section .text
.globl _start
.globl factorial

_start:
  pushl $4 # 1 arg (arrrrg)
  call factorial
  addl $4, %esp
  # Save the result as the status code
  movl %eax, %ebx
  movl $1, %eax # exit
  int $0x80

# This pushes 4,3,2,1 to the stack

factorial:
  # save ebp
  pushl %ebp # stack is now [4 > ret > ebp]
  movl %esp, %ebp # copy esp to ebp
  # Move the first arg to eax, it'll store the result
  movl 8(%ebp), %eax
  # if it's 1, we are donezo
  cmpl $1, %eax
  je end_factorial
  # Decrement our result
  decl %eax
  # Push the result as the arg
  pushl %eax
  call factorial
  movl 8(%ebp), %ebx
  imull %ebx, %eax

end_factorial:
  # restore the original stack pointer
  movl %ebp, %esp
  # pop the arg
  popl %ebp
  ret
