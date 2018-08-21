.include "linux.s"
.include "definitions.s"
.include "write.s"


.section .data

record1:
  .ascii "Fredrick\0"
  .rept 31 # Padding to 31 bytes
  .byte 0
  .endr

  .ascii "Bartlett\0"
  .rept 31 # Padding
  .byte 0
  .endr

  .ascii "4242 S Prairie\nTulsa, OK 5555\0"
  .rept 209 # Padding
  .byte 0
  .endr

  .long 45


record2:
  .ascii "Marilyn\0"
  .rept 32 # Padding
  .byte 0
  .endr

  .ascii "Taylor\0"
  .rept 33 # Padding
  .byte 0
  .endr

  .ascii "2224 S Johannan St\nChicago, IL 12345\0"
  .rept 203 # Padding
  .byte 0
  .endr

  .long 29


record3:
  .ascii "Derrick\0"
  .rept 32 # Padding
  .byte 0
  .endr

  .ascii "McIntire\0"
  .rept 31 # Padding
  .byte 0
  .endr

  .ascii "500 W Oakland\nSan Diego, CA 54321\0"
  .rept 206 # Padding
  .byte 0
  .endr

  .long 36


# Name of the file to write out to
file_name:
  .ascii "test.dat\0"
  .equ FILE_DESC, -4


.globl _start

_start:
  movl %esp, %ebp
  subl $4, %esp
  # Open the file
  movl $SYS_OPEN, %eax
  movl $file_name, %ebx
  movl $0101, %ecx # Create if it doesn't exist and open for writing
  movl $0666, %edx
  int $LINUX_SYSCALL
  # Store the file descriptor
  movl %eax, FILE_DESC(%ebp)

  # Write the first record
  pushl FILE_DESC(%ebp)
  pushl $record1
  call write_record
  addl $8, %esp

  #Write the second record
  pushl FILE_DESC(%ebp)
  pushl $record2
  call write_record
  addl $8, %esp

  #Write the third record
  pushl FILE_DESC(%ebp)
  pushl $record3
  call write_record
  addl $8, %esp

  # Close the file descriptor
  movl $SYS_CLOSE, %eax
  movl FILE_DESC(%ebp), %ebx
  int $LINUX_SYSCALL

  # Exit the program
  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL
