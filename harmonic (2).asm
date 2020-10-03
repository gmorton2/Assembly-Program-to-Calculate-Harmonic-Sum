;Garinn Morton 
;Assembly
;Final

extern printf
extern scanf

global harm

segment .data

initialMsg db "This machine is running an AMD Phenom processor at 2.3GHz.", 10, 0
promptMsg db "Please enter the number of terms to execute: ", 0
initTick db "Timed out: the default 25000 will be used", 10, 0
displayMsg db "With %ld terms the sum is %.10lf", 10, 0
done db "Have a nice day. The sum will be returned to the driver.", 10, 0
stringformat db "%s", 0
numberformat db "%ld", 0

segment .bss

segment .text
harm:

push rbp
mov rbp, rsp
push rbx
push rcx
push rdx
push rdi
push rsi
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15

;======================================prompt msg
mov rax, 0
mov rdi, stringformat
mov rsi, promptMsg
call printf

;==================================calc 6 secs
mov rax, 0
mov rdi, numberformat
push qword 0
mov rsi, rsp
call scanf
pop r15

mov r11, 13800000000
rdtsc
shl rdx, 32
or rdx, rax
mov r12, rdx
cvtsi2sd xmm10, rdx
add r11, r12

;====================================init tick msg

loop:
rdtsc
shl rdx, 32
or rdx, rax
mov r12, rdx
cvtsi2sd xmm10, rdx

cmp r11, r12
jg loop

;======================================default msg
mov rax, 0
mov rdi, stringformat
mov rsi, initTick
call printf

mov r10, 25000

;======================================sum calculations
mov r14, 4       ;number in front
mov r13, 0	 ;inner loop counter

mov rbx, 0x3ff0000000000000 ;1
push rbx

movsd xmm14, [rsp] ;used as the denominator
movsd xmm12, [rsp] ;used to add constant 1 to the denominator 

bLoop:


movsd xmm15, [rsp] ;resetting xmm15(numerator) to 1 every iteration
divsd xmm15, xmm14 ;xmm15=numerator xmm14=denominator
addsd xmm14, xmm12 ;incrementing denominator by 1
addsd xmm13, xmm15 ;xmm13=total
add r13, 1         ;counter for inner loop

cmp r13, r10
jl bLoop
mov rax, 1
mov rdi, displayMsg
mov rsi, r10
movsd xmm0, xmm13
call printf
pop rax

 
;===========================================finish message
mov rax, 0
mov rdi, stringformat
mov rsi, done
call printf

movsd xmm0, xmm13

pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rsi
pop rdi
pop rdx
pop rcx
pop rbx
pop rbp

ret