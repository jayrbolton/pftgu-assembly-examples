.include "linux.s"

.globl write_newline
.type write_newline, @function

.section .data

newline:
  .ascii "\n"
  .section .text
  .equ FILE_DESC, 8

write_newline:
  pushl %ebp
  movl %esp, %ebp
  movl $SYS_WRITE, %eax
  movl FILE_DESC(%ebp), %ebx
  movl $newline, %ecx
  movl $1, %edx
  int $LINUX_SYSCALL
  movl %ebp, %esp
  popl %ebp
  ret
