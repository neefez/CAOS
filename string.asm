; CS 3230 Computer Architecture and Operating Systems
; file: string.asm
; This program shows how handling string in assembly
; 
;
; To create executable :
; nasm -f elf string.asm
; gcc -m32 string.o driver.c asm_io.o
; ./a.exe or ./a.out

%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
;
; These labels refer to strings used for output
;
Menumsg         db "********** Welcome , what you want to do for your string ?**********",0xA  ; 0xA is the ASCII code of \n
                db   "Type Number to Select your option",0xA  
				db   "1 Print the length of your string",0xA
				db   "2 Get the number of vowels in your string",0xA
				db   "3 Print the toggle of your string",0xA
				db   "4 Print your string in reverse order",0xA
				db   "5 Search for a substring in your string",0xA
				db   "6 Exit",0
				   
exitmsg         db "Goodbye",0
entercorrect    db "Please enter a valid option",0
stringIsmsg     db "Your string is:",0
stringlengthmsg db "The string length is:",0
stringvowelmsg  db "The number of vowels in the string is:",0
max_string_size equ 100
; uninitialized data is put in the .bss segment
;
segment .bss
;
; These labels used to store the inputs
;
string           resb max_string_size
togglestring     resb max_string_size
substring        resb max_string_size
substring1       resb max_string_size
string_length    resd 1
substring_length resd 1
vowel_counter    resd 1
;
; code is put in the .text segment
;
segment .text
        global  _asm_main
_asm_main:
	enter   0,0               ; setup routine
	pusha

; read string from user by calling read_string subprogram
	
	push string
	call read_string
	add esp,4
	
; print the string by calling print_string from asm_io.inc	
	call print_nl
	mov eax,stringIsmsg
	call print_string
	mov eax,string
	call print_string
	call print_nl

; find out the length of a string from by calling LengthIs subprogram	
	
	push string
	call LengthIs
	add esp,4
	mov [string_length],eax
	
	
; Print out the menu options

Menu:
	mov eax,Menumsg
	call print_string
	call print_nl
	call read_int
	
	cmp eax, dword 1
	je  print_length
	cmp eax,dword 2
	je  Print_vowelcount
	cmp eax,dword 3
	je Print_toggle
	cmp eax,dword 4
	je Print_reverse
	cmp eax,dword 5
	je Sub_search
	cmp eax,dword 6
	je exitoption
	mov eax,entercorrect
	call print_string
	call print_nl
	jmp Menu
	
print_length:
	mov eax,stringlengthmsg
	call print_string
	call print_nl
	mov  eax,[string_length]
	call print_int
	call print_nl
	jmp Menu
	
Print_vowelcount:
; find how many vowels in the string by calling vowelcount subprogram

	push dword[string_length]
	push string
	call vowelcount
	add esp,8
	
	call print_nl
	mov eax,stringvowelmsg
	call print_string
	mov eax,[vowel_counter]
	call print_int
	call print_nl	
	
	jmp Menu
	

Print_toggle:	
; find the toggle of a string by calling StringToggle subprogram
    
	push dword[string_length]
	push togglestring
	push string
	call StringToggle
	add esp,12
	
	call print_nl
	mov eax,stringIsmsg
	call print_string
	mov eax,togglestring
	call print_string
	call print_nl

	jmp Menu

Sub_search:
; search for a sub string
;1-read the substring and find its length
	
	push substring1
	call read_string
	add esp,4
	
	push substring
	call read_string
	add esp,4
	
	push substring
	call LengthIs
	add esp,4
	mov [substring_length],eax

; 2- call substringfinder subprogram
 
	push substring
	push string
	call substringfinder
	add  esp,8
	call print_nl
	call print_nl
	
	jmp Menu

Print_reverse:	

	push dword[string_length]
	push string
	call stringreverse
	add  esp,8
	call print_nl
	jmp  Menu
	
exitoption:
	
	mov eax,exitmsg
	call print_string
	call print_nl
	
	popa
	mov     eax, 0            ; return back to C
	leave                     
	ret


;.........................................................
;.........................................................
; A subprogram to read a string from keyboard	
segment .data
prompt1 db    "Enter your string: ", 0       ; don't forget nul terminator
	
segment .text
read_string:
	push ebp
	mov ebp,esp
	
	mov ebx,[ebp+8]
	mov esi,0
	mov eax,prompt1
	call print_string
	call print_nl
	mov ecx,max_string_size

get_string:
	call read_char
	cmp  al, 0xA    ;0xA is newline , used to test if capturing enter key from keyboard
	je exit
	mov [ebx+esi],al
	add esi,1
	loop get_string
exit:
	mov byte[ebx+esi], 0  ; ; don't forget nul terminator
	
    
	pop ebp
	ret
	
;.........................................................
;.........................................................
; A subprogram to return the length of a given string

segment .text
LengthIs:
	push ebp
	mov ebp,esp
	
	mov eax,0
	mov ebx,[ebp+8]
	mov esi,0
	mov ecx,max_string_size
length_loop:
	cmp [ebx+esi],dword 0
	je length_exit
	inc eax
	add esi,1
	loop length_loop

length_exit:
	pop ebp
	ret

;.........................................................
; A subprogram to print the toggle of a given string

segment .text	

StringToggle:

	push ebp
	mov ebp,esp
	
	mov eax,0
	mov ebx,[ebp+8]     ; address of original string
	mov edx,[ebp+12]    ; address of toggle string
	mov esi,0
	mov ecx,[ebp+16]   ; length of the string

Toggle_loop:
	mov al,[ebx+esi]
	cmp al,' '
	je exit1   ;don't convert spaces
	cmp al,'A'
	jl  exit1
	cmp al,'z'
	jg  exit1
	cmp al,'a'
	jge  ConvertToUpper
	add al,32  ;ConvertTolower
	jmp exit1
ConvertToUpper:	
	sub al,32
exit1:
	mov [edx+esi],al
	add esi,1
	loop Toggle_loop	

	mov [edx+esi],byte 0  ; append 0 to the end of toggle string
	
	pop ebp
	ret	
	
	
;.........................................................
; A subprogram to count the vowels in a string

segment .text	

vowelcount:

	push ebp
	mov ebp,esp
	
	mov [vowel_counter],dword 0
	mov eax,0
	mov ebx,[ebp+8]     ; address of original string
	mov ecx,[ebp+12]   ; length of the string
	mov esi,0
	
vowel_loop:
	mov al,[ebx+esi]
	cmp al,'a'
	je count
	cmp al,'A'
	je count
	cmp al,'e'
	je count
	cmp al,'E'
	je count
	cmp al,'o'
	je count
	cmp al,'O'
	je count
	cmp al,'u'
	je count
	cmp al,'U'
	je count
	cmp al,'i'
	je count
	cmp al,'I'
	je count
	jmp skip_count
count:
	inc dword[vowel_counter]
skip_count:
	add esi,1
	loop vowel_loop
	
	pop ebp
	ret
	
	
;.........................................................
; A subprogram to check if a substring is exist in a given string

segment .data
;
; These labels refer to strings used for output
;
stringexist     db "The substring is exist!",0
stringnotexist  db "The substring is not exist!",0
segment .bss
stringtemp resd 1
ecxtemp    resd 1

segment .text	

substringfinder:

	push ebp
	mov ebp,esp	
	
	mov eax,0
	mov ebx,[ebp+8]     ; address of original string
	mov edx,[ebp+12]    ; address of sub string
	
	mov esi,0 ; index for original string
	mov edi,0 ; index for substring
	mov ecx,[string_length]

find_loop:
	mov al,[ebx+esi]
	mov ah,[edx+edi]
	cmp al,ah
	je  continue 
back:
	add esi,1
	loop find_loop
; case : not exist
	mov eax,stringnotexist
	call print_string
	jmp exit3
	
continue:
	mov [ecxtemp],ecx
	mov [stringtemp],esi
	mov ecx,[substring_length]
	cmp [substring_length],dword 1
	je xx
	dec ecx
cont_loop:
	add edi,1
	add esi,1
	mov al,[ebx+esi]
	mov ah,[edx+edi]
	cmp al,ah
	jne exit2
	loop cont_loop
; case : exist
	mov eax,stringexist
	call print_string
	jmp exit3
    
exit2:
	mov ecx,[ecxtemp]
	mov esi,[stringtemp]
	mov edi,dword 0
	jmp back

xx:
	mov eax,stringexist
	call print_string
	
exit3:	
		
	pop ebp
	ret  
	
;.........................................................
;.........................................................
; A subprogram to print a string in reverse order	

segment .text

stringreverse:

	push ebp
	mov ebp,esp
	
	mov eax,0
	mov ebx,[ebp+8]     ; address of original string
	mov ecx,[ebp+12]   ; length of the string
	mov esi,[ebp+12]
    dec esi            ; to skip the null terminator
reverse_loop:
	mov al,[ebx+esi]
	call print_char
	sub esi,1
	loop reverse_loop
	call print_nl

	pop ebp
	ret
