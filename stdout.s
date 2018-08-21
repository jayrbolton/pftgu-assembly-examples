.global _start

# Basic stdout example (this one uses x86-64)

.text
_start:
  pushq $11 # message length
  pushq $message
  jmp println

message:
  .ascii  "Hola mundo\n" # message content

println:
  mov $1, %rax # system call 1 is write
  mov $1, %rdi # file handle 1 is stdout
  popq %rsi # address of message
  popq %rdx # length of message
  syscall                         # invoke operating system to do the write
  jmp end

end:
  mov     $60, %rax               # system call 60 is exit
  xor     %rdi, %rdi              # we want return code 0
  syscall                         # invoke operating system to exit
