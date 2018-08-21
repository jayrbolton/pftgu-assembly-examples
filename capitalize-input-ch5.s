# This is based on ./capitalize-file-ch5.s, but modified so that it takes STDIN and returns STDOUT

.section .data

# System call codes
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

# Options for opening a file -- readonly or writeonly
.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

# Standard file descriptors
.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

# Code for a linux system call
.equ LINUX_SYSCALL, 0x80
# End-of-file marker
.equ END_OF_FILE, 0
# Number of arguments to this program (input file, output file)
.equ NUMBER_ARGUMENTS, 0

# Set up buffer space
.section .bss
.equ BUFFER_SIZE, 1024
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

# Stack positions
.equ ST_SIZE_RESERVE, 8
# Memory offset of file descriptor for the input file
.equ ST_FD_IN, -4
# Memory offset of file descriptor for the output file
.equ ST_FD_OUT, -8
# Memory offset of the program arg count
.equ ST_ARGC, 0
# Memory offset of the program name
.equ ST_ARGV_0, 4

.globl _start
_start:
  # Save the stack pointer and allocate space for file descriptors
  movl %esp, %ebp
  subl $ST_SIZE_RESERVE, %esp

# Unnecessary?
# open_stdin:
#   movl $SYS_OPEN, %eax
#   movl $STDIN, %ebx
#   movl $O_RDONLY, %ecx
#   movl $0666, %edx
#   int $LINUX_SYSCALL

# Unnecessary?
# open_stdout:
#   movl $SYS_OPEN, %eax
#   movl $STDOUT, %ebx
#   movl $O_CREAT_WRONLY_TRUNC, %ecx
#   movl $0666, %edx
#   int $LINUX_SYSCALL

read_loop_begin:
  movl $SYS_READ, %eax
  movl $STDIN, %ebx
  movl $BUFFER_DATA, %ecx
  movl $BUFFER_SIZE, %edx
  int $LINUX_SYSCALL
  cmpl $END_OF_FILE, %eax
  jle end_loop

continue_read_loop:
  pushl $BUFFER_DATA
  pushl %eax
  call convert_to_upper
  popl %eax
  addl $4, %esp
  # Write the block to output
  movl %eax, %edx
  movl $SYS_WRITE, %eax
  movl $STDOUT, %ebx
  movl $BUFFER_DATA, %ecx
  int $LINUX_SYSCALL
  # Continue reading blocks
  jmp read_loop_begin

end_loop:
  # # Close stdin - unnecessary?
  # movl $SYS_CLOSE, %eax
  # movl $STDIN, %ebx
  # int $LINUX_SYSCALL
  # # Close stdout - unnecessary?
  # movl $SYS_CLOSE, %eax
  # movl $STDOUT, %ebx
  # int $LINUX_SYSCALL
  # Finally, exit
  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL


# convert_to_upper function 
# -------------------------

.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'

.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12

convert_to_upper:
  pushl %ebp
  movl %esp, %ebp
  movl ST_BUFFER(%ebp), %eax
  movl ST_BUFFER_LEN(%ebp), %ebx
  movl $0, %edi
  cmpl $0, %ebx
  je end_convert_loop

convert_loop:
  # Get the current byte
  movb (%eax,%edi,1), %cl
  # go to the next byte
  cmpb $LOWERCASE_A, %cl
  jl next_byte
  cmpb $LOWERCASE_Z, %cl
  jg next_byte
  addb $UPPER_CONVERSION, %cl
  movb %cl, (%eax,%edi,1)

next_byte:
  incl %edi
  cmpl %edi, %ebx
  jne convert_loop

end_convert_loop:
  movl %ebp, %esp
  popl %ebp
  ret
