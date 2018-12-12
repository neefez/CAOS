;
; Written by Zack Neefe and Xinyi Lyu
;

%include "asm_io.inc"
segment .data

segment .bss
firstInt  resd 1
secondInt resd 1

segment .text
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pusha

		call print_nl
		dump_stack 1, 2, 0
		call int_cin
		call print_nl
		dump_stack 2, 2, 0
		call print_nl
		
		mov eax, [firstInt]
		push eax
		mov eax, [secondInt]
		push eax		
		call gcd_calc
		add esp, 8
		call print_nl
		dump_stack 3, 2, 0
		
		call print_nl
		dump_regs 1
		call print_nl
		dump_mem 1, firstInt, 1
		call print_nl

        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret

;-----------------------------------------------------------------
; A subprogram that reads two positive integers
segment .data
infoPrompt db "Program to find the GCD of two positive integers", 0xA, 0
promptX1   db "Enter the first positive integer: ", 0xA, 0
promptY1   db "Enter the second positive integer: ", 0xA, 0
negError   db "Both integers must be postive.", 0xA, 0
	
segment .text
   int_cin:
      push ebp
	  mov ebp, esp
	  
	  mov ebx, [ebp+12]  ; ebp+8 is firstInt
	  mov ecx, [ebp+8] ; ebp+12 is secondInt
	  mov eax, infoPrompt
	  call print_string 
	  
	  input_loop:
		mov eax, promptX1
		call print_string
		call read_int
		mov [firstInt], eax
		cmp eax, dword 0
		jle bad_input
		mov ebx, eax
		
		mov eax, promptY1
		call print_string
		call read_int
		mov [secondInt], eax
		cmp eax, dword 0
		jle bad_input
		mov ecx, eax
		jmp exit_input_loop
		
		bad_input:
		mov eax, negError
		call print_string
		jmp input_loop
	  exit_input_loop:
	  
	  pop ebp
	  ret

;-----------------------------------------------------------------
; A subprogram that calculates the gcd of two integers
segment .bss
gcd       resd 1

segment .data
output1 db "The GCD of ", 0
output2 db " and ", 0
output3 db " is ", 0
	
segment .text
   gcd_calc:
      push ebp
	  mov ebp, esp
	  
	  mov eax, [ebp+8]  ; ebp+8 is firstInt
	  mov ebx, [ebp+12] ; ebp+12 is secondInt
	  
	  cmp eax, ebx
	  jg gcd_loop
	  mov ebx, [ebp+8]
	  mov eax, [ebp+12]
	  
	  gcd_loop:
	    xor edx, edx    ; clear the edx register
		div ebx
		cmp edx, 0 
		je exit_gcd_loop
		mov eax, ebx
		mov ebx, edx
		jmp gcd_loop
	  exit_gcd_loop:
		mov [gcd], ebx
		
	  mov eax, output1
	  call print_string
	  mov eax, dword[firstInt]
	  call print_int
	  mov eax, output2
	  call print_string
	  mov eax, dword[secondInt]
	  call print_int
	  mov eax, output3
	  call print_string
	  mov eax, [gcd]
	  call print_int
	  call print_nl
	  
	  pop ebp
	  ret