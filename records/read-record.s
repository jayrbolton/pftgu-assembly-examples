.include "definitions.s"
.include "linux.s"

# Local variables
.equ READ_BUFFER, 8
.equ FILE_DESC, 12

.section .text
.globl read_record
.type read_record, @function

read_record:
  pushl %ebp
  movl %esp, %ebp

  pushl %ebx
  movl FILE_DESC(%ebp), %ebx
  movl READ_BUFFER(%ebp), %ecx
  movl $RECORD_SIZE, %edx
  movl $SYS_READ, %eax
  int $LINUX_SYSCALL
  # %eax now has the return value
  popl %ebx
  movl %ebp, %esp
  popl %ebp
  ret
