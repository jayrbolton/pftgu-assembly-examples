.include "linux.s"
.include "definitions.s"

.equ WRITE_BUFFER, 8
.equ FILE_DESC, 12

.section .text
.globl write_record
.type write_record, @function

write_record:
  pushl %ebp
  movl %esp, %ebp
  pushl %ebx
  movl $SYS_WRITE, %eax
  movl FILE_DESC(%ebp), %ebx
  movl WRITE_BUFFER(%ebp), %ecx
  movl $RECORD_SIZE, %edx
  int $LINUX_SYSCALL
  # %eax now has the return value
  popl %ebx
  movl %ebp, %esp
  popl %ebp
  ret
