;
; Written by Zack Neefe and Xinyi Lyu
;

%include "asm_io.inc"
segment .data
infoPrompt db "Program to find the slope of a line given two end points", 0xA, 0
promptX1   db "Enter X1: ", 0
promptY1   db "Enter Y1: ", 0
promptX2   db "Enter X2: ", 0
promptY2   db "Enter Y2: ", 0
outPrompt1 db "Slope of the line with end points (", 0
outPrompt2 db ", ", 0
outPrompt3 db ") and (", 0
outPrompt4 db ") = ", 0

segment .bss
slope resd 1
x1    resd 1
x2	  resd 1
y1	  resd 1
y2 	  resd 1
run   resd 1
rise  resd 1 

segment .text
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pusha

		mov ecx, 0
		mov edx, 0
		mov eax, infoPrompt
		call print_string
		mov eax, promptX1
		call print_string
		call read_int
		mov dword[x1], eax
				
		mov eax, promptY1
		call print_string
		call read_int
		mov dword[y1], eax		
		
		mov eax, promptX2
		call print_string
		call read_int
		mov dword[x2], eax		
		
		mov eax, promptY2
		call print_string
		call read_int
		mov dword[y2], eax
		
		dump_regs 1         ; dump out register values
        dump_mem 2, x1, 1   ; dump out memory
		
		mov eax, dword[x2]
		mov ebx, dword[x1]
		sub eax, ebx
		mov dword[run], eax
		
		mov eax, dword[y2]
		mov ebx, dword[y1]
		sub eax, ebx
		mov dword[rise], eax
		
		mov eax, dword[rise]
		mov ebx, dword[run]
		cdq                  ; clear the edx register
		cmp ebx, 0
		je output_results
		idiv ebx
		mov ebx, eax
		
		output_results:
		mov eax, outPrompt1
		call print_string
		mov eax, dword[x1]
		call print_int
		mov eax, outPrompt2
		call print_string
		mov eax, dword[y1]
		call print_int
		mov eax, outPrompt3
		call print_string
		mov eax, dword[x2]
		call print_int
		mov eax, outPrompt2
		call print_string
		mov eax, dword[y2]
		call print_int
		mov eax, outPrompt4
		call print_string
		mov eax, ebx
		call print_int
		
		call print_nl

        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret