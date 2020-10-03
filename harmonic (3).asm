extern printf
extern scanf

global harm

segment .data

initialMsg db "This machine is running an AMD Phenom processor at 2.3GHz.", 10, 0
promptMsg db "Please enter the number of terms to be included in the harmonic sum: ", 0
initTick db "The clock is now %ld tics and the computation will begin immediately", 10, 10, 0
sum db "Final sum is %.10lf", 10, 10, 0
displayMsg db "With %ld terms the sum is %.10lf", 10, 0
postTick db "The clock is now %ld and the computation is complete", 10, 0
sec db "The elapsed time was %.0lf tics. At 2.3GHz that is %.9lf seconds", 10, 0
done db "The assembly program will now return the harmonic sum to the driver program.", 10, 0
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

;=====================================inti message
mov rax, 0
mov rdi, stringformat
mov rsi, initialMsg
call printf

;======================================prompt msg
mov rax, 0
mov rdi, stringformat
mov rsi, promptMsg
call printf

;==================================Scan number inputed by the user
mov rax, 0
mov rdi, numberformat
push qword 0
mov rsi, rsp
call scanf
pop r15

;====================================init tick msg
rdtsc
shl rdx, 32
or rdx, rax
mov r12, rdx
cvtsi2sd xmm10, rdx

mov rax, 0                                          
mov rdi, initTick                              
mov rsi, r12       ;rdx holds initial tick number       
call printf 

;======================================sum calculations
mov r14, 4       ;number in front
mov r13, 0	 ;inner loop counter

mov rbx, 0x3ff0000000000000 ;1
push rbx

movsd xmm14, [rsp] ;used as the denominator
movsd xmm12, [rsp] ;used to add constant 1 to the denominator 

bLoop:

iLoop:
movsd xmm15, [rsp] ;resetting xmm15(numerator) to 1 every iteration
divsd xmm15, xmm14 ;xmm15=numerator xmm14=denominator
addsd xmm14, xmm12 ;incrementing denominator by 1
addsd xmm13, xmm15 ;xmm13=total
add r13, 1         ;counter for inner loop
cmp r13, r14       ;if counter is less than r14 then keep looping 
jl iLoop

mov rax, 1
mov rdi, displayMsg
mov rsi, r14
movsd xmm0, xmm13
call printf
add r14, 4
cmp r14, r15
jle bLoop
pop rax

;=========================================sum message
push qword 99
mov rax, 1
mov rdi, sum
movsd xmm0, xmm13
call printf
pop rax

;====================================later tick msg
rdtsc
shl rdx, 32
or rdx, rax
mov r11, rdx
cvtsi2sd xmm11, rdx

mov rax, 0                                          
mov rdi, postTick                              
mov rsi, r11       ;rdx holds initial tick number       
call printf 

;===========================================difference and seconds
movsd xmm12, xmm11
subsd xmm12, xmm10
movsd xmm14, xmm12

mov rbx, 0x4002666666666666 ;2.3
push rbx
movsd xmm10, [rsp] ;move 2.3 into xmm10
divsd xmm14, xmm10 ;divide difference by 2.3

mov rbx, 0x41cdcd6500000000 ;1 billion
push rbx
movsd xmm15, [rsp]
divsd xmm14, xmm15
pop rbx

mov rax, 2
mov rdi, sec
movsd xmm0, xmm12
movsd xmm1, xmm14
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