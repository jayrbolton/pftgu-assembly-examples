# Count the number of characters until the null byte is reached

.globl count_chars
.type count_chars @function

.equ STRING_START_ADDR, 8

count_chars:
  pushl %ebp
  movl %esp, %ebp
  # Our counter is in %ecx and starts at 0
  movl $0, %ecx
  # Our character pointer
  movl STRING_START_ADDR(%ebp), %edx

count_loop:
  # Grab the current character
  movb (%edx), %al
  # Is it null
  cmpb $0, %al
  # If yes, we're done
  je count_loop_end
  # Otherwise, increment the counter and pointer
  incl %ecx
  incl %edx
  # Repeat the loop
  jmp count_loop

count_loop_end:
  movl %ecx, %eax # Use eax as the return val register
  popl %ebp
  ret
