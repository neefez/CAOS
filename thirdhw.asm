;
; Written by Zack Neefe and Xinyi Lyu
;
%include "asm_io.inc"
segment .data
prompt1 db "PLEASE SELECT AN OPTION FROM THE MENU:", 0xA
        db "--------------------------------------", 0xA
        db "1. Enter a new string", 0xA
        db "2. Count the number of words in your string", 0xA
        db "3. Remove leading and duplicate blank characters in your received string", 0xA
        db "4. Reverse the words in your string", 0xA
        db "5. Test if your string is palindrome", 0xA
        db "6. Exit", 0xA
        db "", 0xA
        db "Choice #: ", 0
promptA db "Enter a new string: ", 0
promptB db "Your string is: ", 0
promptC db "The number of words in: ", 0
promptD db " is ", 0
promptE db "After removing leading and duplicate blank characters: ", 0
promptF db "After reversing the words: ", 0
promptG db "The string: ", 0
promptH db " is a palindrome", 0
promptI db " is not a palindrome", 0
promptJ db "Goodbye", 0

max_string_size equ 100

segment .bss
myString resb max_string_size
wordCount resd 1
stringLength resd 1
formattedString resb max_string_size
isPalindrome resd 1

segment .text
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pusha

        menu:
		    call print_nl
			mov eax, prompt1
		    call print_string
		    call read_int
		    call print_nl
		
		    cmp eax, 1
		    je select_read_string
		    cmp eax, 2
		    je select_count_words
	   	    cmp eax, 3
		    je select_remove_spaces
		    cmp eax, 4
		    je select_reverse_words
		    cmp eax, 5
		    je select_is_palindrome
		    cmp eax, 6
		    je exit
           
		    jmp menu
		   
		select_read_string:
			mov eax, myString
			mov ecx, max_string_size
			mov ebx, 0
			clear_loop:
				mov [eax+ebx], dword 0
				add ebx, 4
				loop clear_loop
			push eax
			call read_string
			add esp, 4
			mov eax, promptB
			call print_string
			mov eax, myString
			call print_string
			call print_nl
			
			jmp menu
			
		select_count_words:
			mov eax, myString
			push eax
			mov eax, wordCount
			push eax
			call count_words
			add esp, 8
			mov eax, promptC
			call print_string
			mov eax, myString
			call print_string
			mov eax, promptD
			call print_string
			mov eax, [wordCount]
			call print_int
			call print_nl
			jmp menu
			
		select_remove_spaces:
			mov eax, stringLength
			push eax
			mov eax, myString
			push eax
			call find_length
			add esp, 8
			
			mov eax, formattedString
			push eax
			mov eax, stringLength
			push eax
			mov eax, myString
			push eax
			call remove_spaces
			add esp, 12
			
			mov eax, promptB
			call print_string
			mov eax, myString
			call print_string
			call print_nl
			mov eax, promptE
			call print_string
			mov eax, formattedString
			call print_string
			call print_nl
			jmp menu

		select_reverse_words:
			mov eax, promptB
			call print_string
			mov eax, myString
			call print_string
			call print_nl
			
			mov eax, stringLength
			push eax
			mov eax, myString
			push eax
			call find_length
			add esp, 8
			
			mov eax, formattedString
			push eax
			mov eax, stringLength
			push eax
			mov eax, myString
			push eax
			call remove_spaces
			add esp, 12
			
			mov eax, stringLength
			push eax
			mov eax, formattedString
			push eax
			call find_length
			add esp, 8
			
			mov eax, stringLength
			push eax
			mov eax, formattedString
			push eax
			call reverse_words
			add esp, 8
			jmp menu
			
		select_is_palindrome:
			mov eax, stringLength
			push eax
			mov eax, myString
			push eax
			call find_length
			add esp, 8
			
			mov eax, isPalindrome
			push eax
			mov eax, stringLength
			push eax
			mov eax, myString
			push eax
			call is_palindrome
			add esp, 12
			
			mov eax, formattedString
			push eax
			mov eax, stringLength
			push eax
			mov eax, myString
			push eax
			call remove_spaces
			add esp, 16
			
			cmp [isPalindrome], dword 0
			je not_palin_msg
			mov eax, promptG
			call print_string
			mov eax, formattedString
			call print_string
			mov eax, promptH
			call print_string
			call print_nl
			jmp menu
			
			not_palin_msg:
				mov eax, promptG
				call print_string
				mov eax, formattedString
				call print_string
				mov eax, promptI
				call print_string
				call print_nl
				jmp menu
			
		exit:
			mov eax, promptJ
			call print_string
			call print_nl
			call print_nl
		
        popa
        mov     eax, 0            ; return back to C
        leave                     
        ret

;-----------------------------------------------------------------
; A subprogram that prompts the user to input a string and gets it
segment .data
	promptReadString db "Enter a new string: ", 0
segment .text
   read_string:
      push ebp
	  mov ebp, esp
	  
	  mov ebx, [ebp+8]
	  mov esi, 0
	  mov eax, promptReadString
	  call print_string
	  mov ecx, max_string_size
	  call read_char
	  
	  get_string:
	     call read_char
		 cmp al, 0xA
		 je exit_get_string
		 mov [ebx+esi], al
		 add esi, 1
		 loop get_string
      exit_get_string:
	  mov byte[ebx+esi], 0
	  
	  pop ebp
	  ret

;------------------------------------------------------------------
; A subprogram that counts the words in the string
segment .bss
	inWord resd 1
	tempCount resd 1
segment .text
	count_words:
		push ebp
		mov ebp, esp
		
		mov eax, 0
		mov [inWord], eax
		mov [tempCount], eax
		mov esi, 0
		mov ecx, max_string_size
		mov ebx, [ebp+12]
		count_loop:
			mov al, byte[ebx+esi]
			cmp al, 0xA
			je exit_count_loop
			cmp al, 0x20
			je not_in_word
			mov eax, [inWord]
			cmp eax, 1
			je cont_count_loop
			mov eax, 1
			mov [inWord], eax
			mov eax, [tempCount]
			add eax, 1
			mov [tempCount], eax
		    jmp cont_count_loop
			not_in_word:
				mov eax, 0
				mov [inWord], eax
			cont_count_loop:
			add esi, 1
			loop count_loop
		exit_count_loop:
		mov ebx, [ebp+8]
		mov eax, [tempCount]
		mov [ebx], eax
		
		pop ebp
		ret
		
;------------------------------------------------------------
; Subprogram to remove leading and duplicate spaces in string
segment .bss
	isFront resd 1
	tempChar resb 1
	
segment .text
	remove_spaces:
		push ebp
		mov ebp, esp
		
		mov eax, 0
		mov [isFront], eax
		mov al, 0x61
		mov [tempChar], al
		mov ebx, [ebp+8]  ; ebp+8 is the string
		mov edx, [ebp+16] ; ebp+16 is the formatted string
		
		mov esi, 0        ; i
		mov edi, 0        ; j
		mov eax, [ebp+12] ; ebp+12 is the string length
		mov ecx, [eax]
		
		remove_loop:
			cmp [ebx+esi], byte 0x20
			je not_space
			mov eax, 0
			mov [isFront], eax
			mov al, [tempChar]
			cmp al, 0x20
			jne not_space_2			
			mov [edx+edi], byte 0x20
			add edi, 1
			not_space_2:
				mov al, [ebx+esi]
				mov [edx+edi], al
				add edi, 1
			not_space:
				mov eax, [isFront]
				cmp eax, 0
				jne cont_remove_loop
				mov al, [ebx+esi]
				mov [tempChar], al
			cont_remove_loop:
				add esi, 1
				loop remove_loop
				
		mov [edx+edi], byte 0
		
		cmp [edx], byte 0x20
		jne exit_front_space		
		mov esi, 0		
		mov ecx, edi
		front_space_loop:
			mov [isFront], esi
			mov edi, [isFront]
			add edi, 1
			mov al, [edx+edi]
			mov [edx+esi], al
			add esi, 1
			loop front_space_loop
		exit_front_space:
		
		pop ebp
		ret
					
;------------------------------------------------------------
; Subprogram to count return the length of the string
segment .text
	find_length:
		push ebp
		mov ebp, esp
		
		mov eax, 0
		mov ebx, [ebp+8]
		mov esi, 0
		mov ecx, max_string_size
		length_loop:
			cmp [ebx+esi], dword 0
			je length_exit
			inc eax
			add esi, 1
			loop length_loop
		length_exit:
		mov eax, [ebp+12]
		mov [eax], esi
		
		pop ebp
		ret
		
;------------------------------------------------------------
; Subprogram to reverse the order of the words in the string
segment .bss
	reverseString resb max_string_size
	reverseWordSize resd 1
	temp_ecx resd 1
segment .text
	reverse_words:
		push ebp
		mov ebp, esp
		
		mov eax, [ebp+12]
		mov ecx, [eax]
		mov esi, 0
		mov edi, ecx
		sub edi, 1
		mov ebx, [ebp+8]
		reverse_loop:
			mov al, [ebx+esi]
			cmp al, 0x20
			je cont_reverse_loop
			mov [reverseString+edi], al			
			cont_reverse_loop:
			add esi, 1
			sub edi, 1
			loop reverse_loop
		mov [reverseString+esi], byte 0
		
		mov eax, promptF
		call print_string
		
		mov eax, 0
		mov [reverseWordSize], eax
		mov eax, [ebp+12]
		mov ecx, [eax]
		mov esi, 0
		reverse_print_loop:
			mov al, [reverseString+esi]
			cmp al, 0x20
			je goto_inner_loop
			mov ebx, esi
			add ebx, 1
			mov al, [reverseString+ebx]
			cmp al, byte 0
			je goto_inner_loop
			jmp goto_else
			
			goto_inner_loop:
			mov [temp_ecx], ecx
			mov ecx, [reverseWordSize]
			add ecx, 1
			mov edi, 0
			inner_loop:
				mov ebx, esi
				sub ebx, edi
				mov al, [reverseString+ebx]
				call print_char
				add edi, 1
				loop inner_loop
			mov al, 0x20
			call print_char
			mov eax, 0
			mov [reverseWordSize], eax
			mov ecx, [temp_ecx]
			jmp cont_reverse_print_loop
			
			goto_else:
				mov eax, [reverseWordSize]
				add eax, 1
				mov [reverseWordSize], eax
			cont_reverse_print_loop:
			add esi, 1
			loop reverse_print_loop
		call print_nl
		
		pop ebp
		ret
		
;----------------------------------------------------
; Subprogram to check if the string is a palindrome
segment .bss
    palinString    resd 1
	stringPosition resd 1
	returnPalin    resd 1
segment .text
	is_palindrome:
		push ebp
		mov ebp, esp
		
		mov eax, [ebp+8]   ; ebp+8 is the string
		mov ebx, 0
		mov edx, [ebp+16]
		mov esi, 0
		mov edi, 0
		mov [stringPosition], dword 0
		mov ecx, [ebp+12]  ; ebp+12 is the string length
		format_palin_loop:
		    cmp [eax+esi], byte 0
			je exit_format_palin_loop
			
			cmp [eax+esi], byte 0x7A ; checks if greater than z
			jg end_format_loop
			cmp [eax+esi], byte 0x30 ; checks if less than 0
			jl end_format_loop
			
			cmp [eax+esi], byte 0x41 ; checks if less than A
			jge palin_num_check
			cmp [eax+esi], byte 0x39 ; checks if greater than 9
			jg end_format_loop			
			palin_num_check:
			
			cmp [eax+esi], byte 0x61 ; checks if less than a
			jge palin_letter_check
			cmp [eax+esi], byte 0x5A ; checks if greater than Z
			jg end_format_loop
			palin_letter_check:
			
			mov ebx, [eax+esi]
		    cmp [eax+esi], byte 0x61 ; checks if letter is lowercase
			jl add_format_loop
			sub bl, byte 0x20        ; makes lowercase into uppercase
			
			add_format_loop:
		    mov [edx+edi], ebx
			add [stringPosition], dword 1
			add edi, 1
		    end_format_loop:
			add esi, 1
			
			loop format_palin_loop
			
		exit_format_palin_loop:
		mov [edx+edi], byte 0
		mov eax, [stringPosition]
		mov ecx, eax
		sub edi, 1
		sub [stringPosition], dword 1
		mov esi, 0    ; i
		palin_loop:
			mov eax, [edx+esi]
			mov ebx, [edx+edi]
			cmp al, bl
			je cont_palin
			mov eax, 0
			mov [returnPalin], eax
			jmp end_palin_loop
			cont_palin:
			sub edi, 1
			sub [stringPosition], dword 1
			add esi, 1
			loop palin_loop
		mov eax, 1
		mov [returnPalin], eax
		end_palin_loop:
		mov eax, [ebp+16]
		mov ebx, [returnPalin]
		mov [eax], ebx
		
		pop ebp
		ret
		