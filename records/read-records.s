.include "linux.s"
.include "definitions.s"

.section .data

file_name:
  .ascii "test.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text

.globl _start
_start:
  .equ INPUT_DESC, -4 # Memory offset of input file desc
  .equ OUTPUT_DESC, -8 # Memory offset of output file desc
  movl %esp, %ebp
  subl $8, %esp
  # Open the file
  movl $SYS_OPEN, %eax
  movl $file_name, %ebx
  movl $0, %ecx
  movl $0666, %edx
  int $LINUX_SYSCALL
  # Save the file descriptor
  movl %eax, INPUT_DESC(%ebp)
  movl $STDOUT, OUTPUT_DESC(%ebp)

record_read_loop:
  pushl INPUT_DESC(%ebp)
  pushl $record_buffer
  call read_record
  addl $8, %esp

  # Returns number of bytes read
  cmpl $RECORD_SIZE, %eax
  # If not-equal, something is wrong
  jne finished_reading
  # Otherwise, print out the rec
  # Get its size
  pushl $RECORD_FIRSTNAME + record_buffer
  call count_chars
  addl $4, %esp
  movl %eax, %edx
  movl OUTPUT_DESC(%ebp), %ebx
  movl $SYS_WRITE, %eax
  movl $RECORD_FIRSTNAME + record_buffer, %ecx
  int $LINUX_SYSCALL
  pushl OUTPUT_DESC(%ebp)
  call write_newline
  addl $4, %esp
  jmp record_read_loop

finished_reading:
  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL
