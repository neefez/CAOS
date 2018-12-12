; Zackary Neefe
;
; file: firsthw.asm
; First assembly homework. This program asks for two integers as
; input and prints out their sum, difference, product, and quotient.
;
; To create executable:
; Using djgpp:
; nasm -f coff first.asm
; gcc -o first first.o driver.c asm_io.o
;
; Using Linux and gcc:
; nasm -f elf first.asm
; gcc -o first first.o driver.c asm_io.o
;
; Using Borland C/C++
; nasm -f obj first.asm
; bcc32 first.obj driver.c asm_io.obj
;
; Using MS C/C++
; nasm -f win32 first.asm
; cl first.obj driver.c asm_io.obj
;
; Using Open Watcom
; nasm -f obj first.asm
; wcl386 first.obj driver.c asm_io.obj

%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
;
; These labels refer to strings used for output
;
prompt1 db    "Enter first integer: ", 0   ; has null terminator
prompt2 db    "Enter second integer: ", 0
outmsg1 db    "The sum is: ", 0
outmsg2 db    "The difference is: ", 0
outmsg3 db    "The product is: ", 0
outmsg4 db    "The quotient is: ", 0

;
; uninitialized data is put in the .bss segment
;
segment .bss
;
; These labels refer to double words used to store the inputs and results
;
input1     resd 1
input2     resd 1
sum        resd 1
difference resd 1
product    resd 1
quotient   resd 1

;
; code is put in the .text segment
;
segment .text
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pusha

        mov     eax, prompt1      ; print out prompt
        call    print_string

        call    read_int          ; read integer
        mov     [input1], eax     ; store into input1

        mov     eax, prompt2      ; print out prompt
        call    print_string

        call    read_int          ; read integer
        mov     [input2], eax     ; store into input2
;
; Perform arithmetic operations
;
        mov     eax, [input1]     ; eax = dword at input1
        add     eax, [input2]     ; eax += dword at input2
        mov     [sum], eax        ; sum = eax
		
        mov     eax, [input1]
        sub     eax, [input2]     ; eax -= dword at input2
        mov     [difference], eax ; difference = eax
		
        mov     eax, [input1]
        mul     dword[input2]     ; eax *= dword at input2
		mov     [product], eax    ; product = eax
		
		mov     eax, [input1]     
		div     dword[input2]     ; eax = eax / dword at input2
        mov     [quotient], eax   ; quotient = eax
		
        dump_regs 1               ; dump out register values
        dump_mem 2, outmsg1, 1    ; dump out memory
;
; Print the results
;
        mov     eax, outmsg1
        call    print_string      ; print out sum message
        mov     eax, [sum]
        call    print_int         ; print out sum
        call    print_nl          ; print new-line

		mov     eax, outmsg2
		call    print_string      ; print out difference message
		mov     eax, [difference]  
		call    print_int         ; print out difference
		call    print_nl          ; print new-line
		
		mov     eax, outmsg3
		call    print_string      ; print out product message
		mov     eax, [product]      
		call    print_int         ; pint out product
		call    print_nl          ; print new-line
		
		mov     eax, outmsg4  
		call    print_string      ; print out quotient message
		mov     eax, [quotient]     
		call    print_int         ; print out quotient
		call    print_nl          ; print out new-line
		
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret


