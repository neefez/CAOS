; Written by Zack Neefe and Xinyi Lyu
;
%include "asm_io.inc"
segment .data
;
; initialized data is put in the data segment here
;
prompt1 db "How many lockers are there? ", 0
result1 db "The open lockers are: ", 0
space1  db " ", 0

segment .bss
;
; uninitialized data is put in the bss segment
;
lockers resd 1
current resd 1
student resd 1
visits  resd 1

segment .text
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pusha
		
		mov eax, prompt1
		call print_string
		
		call read_int
		mov [lockers], eax
		call print_nl
		
		mov eax, result1
		call print_string
		
		mov dword[student], 0
	    mov dword[current], 0
		first_loop:
			inc dword[current]
			mov dword[visits], 0
			mov dword[student], 0
			
			second_loop:
			   inc dword[student]
			   mov edx, 0
			   mov eax, [current]
			   mov ebx, [student]
			   div ebx
			   cmp edx, 0
			   jne second_loop_end
			   inc dword[visits]
			   
			   second_loop_end:
			   mov eax, [student]
			   mov ebx, [lockers]
			   cmp eax, ebx
		       jl second_loop
			   
			mov edx, 0
			mov eax, [visits]
			mov ebx, 2
			div ebx
			cmp edx, 1
			jne dont_output
			mov eax, [current]
		   	call print_int
		   	mov eax, space1
			call print_string
			   
			dont_output:  
		    mov eax, [current]
			mov ebx, [lockers]
			cmp eax, ebx
			jl first_loop
        call print_nl

        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


