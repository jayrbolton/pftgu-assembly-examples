; This is a NASM solution to Project Euler Problem #1
; Compile on linux with:  nasm -felf64 euler1.asm && gcc euler1.o && ./a.out
; Clean up:  rm euler1.o && rm a.out

extern printf

section .text
global main

; rax (return) rdi rsi rdx rcx r8 r9 r10 r11

main:
  ; cdecl..
  push rbp
  mov rbp, rsp

  ; mult sum of 15
  mov rdi, 15
  call mult_sum
  push rax

  ; mult sum of 3
  mov rdi, 3
  call mult_sum  ; rax <- some of 3s up to 1000
  push rax

  ; mult sum of 5
  mov rdi, 5
  call mult_sum
  push rax

  ; add m3 and m5
  pop rax
  pop rsi
  add rax, rsi
  pop rsi
  sub rax, rsi

  ; printf
  mov rdi, message
  mov rsi, rax
  call printf

  ; cdecl..
  mov rsp, rbp
  pop rbp
  ret

; function mult_sum = (n :int) -> :int
; sum of multiples of n up to 1000
mult_sum:
  ; cdecl
  push rbp
  mov rbp, rsp
  mov rsi, rdi     ; multiples
  mov rax, 0       ; current sum (return val)
mult_sum_loop:
  cmp rsi, 1000      ; rsi > 1000 ?
  jge mult_sum_end    ; then we're done
  add rax, rsi       ; rax <- rax + rdi
  add rsi, rdi       ; rdi <- rdi + 3
  jmp mult_sum_loop  ; repeat
mult_sum_end:
  ; cdecl
  mov rsp, rbp
  pop rbp
  ret

section .data

message: db "val is %d", 10, 0
