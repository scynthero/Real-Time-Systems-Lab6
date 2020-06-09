
; _testLoop:
; ; ;;test print 
; mov edx, [input_buffer + ecx]
; ; add edx, 48
; cmp edx, 0
; je _endtestLoop
; inc ecx
; push edx
; lea ebx, [esp]
; pusha
; push dword 0
; push dword actually_wrote ;; ile bajtów wyświetlono
; push dword size2 ;; ile bajtów mamy wyświetlić znajduje się pod >adresem< actually_read
; push dword ebx;;input buffer
; push dword [write_handle]
; call [WriteFile]
; popa
; cmp ecx, 20
; je _endtestLoop
; jmp _testLoop
; _endtestLoop:
; ;;end test print

; xor eax, eax
; xor ebx, ebx
; xor ecx, ecx
; xor edx, edx
;start letter counter
