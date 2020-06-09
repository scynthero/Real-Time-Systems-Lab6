;; funkcje z bibliotek
extern GetStdHandle
extern WriteFile
extern AllocConsole
extern FreeConsole
extern SetConsoleTitleA
extern Sleep
extern ExitProcess
extern ReadFile

import GetStdHandle kernel32.dll
import WriteFile kernel32.dll
import AllocConsole kernel32.dll
import FreeConsole kernel32.dll
import SetConsoleTitleA kernel32.dll
import Sleep kernel32.dll
import ExitProcess kernel32.dll
import ReadFile kernel32.dll

;; stałe pomocnicze
write_handle_id equ -11 ;; ta wartość, przekazywana jako argument funkcji [GetStdHandle]
  ;; pozwoli uzyskać uchwyt do konsoli, do zapisu
read_handle_id equ -10 ;; ta wartość pozwoli uzyskać uchwyt do konsoli, do odczytu
  ;; tak, to są dwie różne wartości
input_buffer_size equ 500 ;; maksymalnie 50 bajtów będzie mógł mieć komunikat podawany przez użytkownika

section .text use32 ;; kod programu

..start:
call [AllocConsole] ;; tworzenie konsoli
push dword title 
call [SetConsoleTitleA] ;; ustawianie tytułu

;; pobieranie uchwytów
push dword write_handle_id
call [GetStdHandle]
mov dword [write_handle], eax
push dword read_handle_id
call [GetStdHandle]
mov dword [read_handle], eax

startloop:
;;wyświetlanie komunikatu msg1
push dword 0
push dword actually_wrote
push dword size1
push dword msg1
push dword [write_handle]
call [WriteFile]

;; odczytwanie komunikatu wpisanego przez użytkownika
push dword 0
push dword actually_read ;; tutaj dostaniemy informację zwrotną: ile bajtów (znaków) użytkownik faktycznie wpisał
push dword input_buffer_size ;; maksymalny rozmiar komunikatu
push dword input_buffer ;; tutaj, czyli pod adresem input_buffer, funkcja [ReadFile] zwróci wpisany komunikat
push dword [read_handle] ;; przekazujemy uchwyt do konsoli do >odczytu<
call [ReadFile]

; push eax
mov ah, byte [input_buffer] ;; przenosimy pierwszy bajt z adresu bufor_wejscia do AH
cmp ah, byte [zerolen]
; pop eax
je endloop

;; here starts loop for counting length of string
mov eax, [actually_read]
sub eax, 2
push 0 ;;push null to indicate string stop
_counterLoop:
mov edx, 0
mov ecx, 10
div ecx
add edx, 48
push dword edx
cmp eax, 0
jne _counterLoop
;; here counting loop ends and printing stars
;; it all works using stack, to reverse order

pusha
push dword 0
push dword actually_wrote
push dword sizenoac
push dword noac
push dword [write_handle]
call [WriteFile]
popa

_printerLoop:
;; get from stack
lea ebx, [esp]
cmp dword [ebx], 0
je _stopPrint ;; stop print if null on stack
;; save the registers
;; then push data to print
pusha
push dword 0
push dword actually_wrote ;; ile bajtów wyświetlono
push dword size2 ;; ile bajtów mamy wyświetlić znajduje się pod >adresem< actually_read
push dword ebx ;;input buffer
push dword [write_handle]
call [WriteFile]
popa
pop ecx
jmp _printerLoop

_stopPrint: ;; print new line for clearance
push 10
lea ebx, [esp]
pusha
push dword 0
push dword actually_wrote ;; ile bajtów wyświetlono
push dword size2 ;; ile bajtów mamy wyświetlić znajduje się pod >adresem< actually_read
push dword ebx ;;input buffer
push dword [write_handle]
call [WriteFile]
popa
pop ecx

jmp startloop

endloop:

; pauza i zakończenie pracy
; push dword 2000
; call [Sleep]

call [FreeConsole] 
xor eax, eax
push eax
call [ExitProcess]



section .data ;; dane programu
title db "Zadanie 1", 0
msg1 db "Enter text: ", 0
size1 equ $ - msg1 - 1
noac db "Number of all chars is: ", 0
sizenoac equ $ - noac - 1
size2 equ 1
zerolen db 13

section .bss
write_handle resd 1
read_handle resd 1
actually_wrote resd 1
input_buffer resb input_buffer_size
actually_read resd 1