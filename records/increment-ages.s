# Read in a record file, increment all ages, and write to an output file
.include "linux.s"
.include "definitions.s"

.section .data
input_file_name:
  .ascii "test.dat\0"
output_file_name:
  .ascii "test.out.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

# Local vars
.equ INPUT_FILE_DESC, -4
.equ OUTPUT_FILE_DESC, -8

.section .text
.globl _start

_start:
  movl %esp, %ebp
  subl $8, %esp # Make room for local vars

  # Open input file
  movl $SYS_OPEN, %eax
  movl $input_file_name, %ebx
  movl $0, %ecx
  movl $0666, %edx
  int $LINUX_SYSCALL
  # Save file descriptor
  movl %eax, INPUT_FILE_DESC(%ebp)
  # Open output file
  movl $SYS_OPEN, %eax
  movl $output_file_name, %ebx
  movl $0101, %ecx
  movl $0666, %edx
  int $LINUX_SYSCALL
  # Save file descriptor
  movl %eax, OUTPUT_FILE_DESC(%ebp)

loop_begin:
  pushl INPUT_FILE_DESC(%ebp)
  pushl $record_buffer
  call read_record
  addl $8, %esp
  # Check that the number of bytes read is the same as the amount requested
  cmpl $RECORD_SIZE, %eax
  jne loop_end
  # Otherwise, increment the age
  incl record_buffer + RECORD_AGE
  # Write the record to the output
  pushl OUTPUT_FILE_DESC(%ebp)
  pushl $record_buffer
  call write_record
  addl $8, %esp
  jmp loop_begin

loop_end:
  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL
