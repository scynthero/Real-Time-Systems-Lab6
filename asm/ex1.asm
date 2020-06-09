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


;########### CHAR LOOP #########
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
;;end of all chars coutner

xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx
;################## LETTER LOOP #############
mov ecx, 0
_letterCounter:
mov ah, [input_buffer + ecx]
inc ecx
cmp ah, 13
je _endletterCounter
cmp ah, 122
jg _letterCounter
cmp ah, 65
jl _letterCounter
cmp ah, 96
jg _increment
cmp ah, 91
jl _increment
jmp _letterCounter
_increment:
inc edx
jmp _letterCounter
_endletterCounter:
;; end of letter
xor eax, eax
xor ebx, ebx
xor ecx, ecx
mov eax, edx
push 0 ;;push null to indicate string stop
_counterLoop1:
mov edx, 0
mov ecx, 10
div ecx
add edx, 48
push dword edx
cmp eax, 0
jne _counterLoop1
;; here counting loop ends and printing stars
;; it all works using stack, to reverse order
pusha
push dword 0
push dword actually_wrote
push dword sizenol
push dword nol
push dword [write_handle]
call [WriteFile]
popa
_printerLoop1:
;; get from stack
lea ebx, [esp]
cmp dword [ebx], 00
je _stopPrint1 ;; stop print if null on stack
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
jmp _printerLoop1

_stopPrint1: 
push 10;; print new line for clearance
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
;;end of letter counter
xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx
;############### DIGIT LOOP #############

mov ecx, 0
_digitCounter:
mov ah, [input_buffer + ecx]
inc ecx
cmp ah, 13
je _enddigitCounter
cmp ah, 57
jg _digitCounter
cmp ah, 48
jl _digitCounter
inc edx
jmp _digitCounter
_enddigitCounter:
;; end of digit
xor eax, eax
xor ebx, ebx
xor ecx, ecx
mov eax, edx
push 0 ;;push null to indicate string stop
_counterLoop2:
mov edx, 0
mov ecx, 10
div ecx
add edx, 48
push dword edx
cmp eax, 0
jne _counterLoop2
;; here counting loop ends and printing stars
;; it all works using stack, to reverse order
pusha
push dword 0
push dword actually_wrote
push dword sizenod
push dword nod
push dword [write_handle]
call [WriteFile]
popa
_printerLoop2:
;; get from stack
lea ebx, [esp]
cmp dword [ebx], 00
je _stopPrint2 ;; stop print if null on stack
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
jmp _printerLoop2

_stopPrint2: 
push 10;; print new line for clearance
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
xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx

;############### WORD LOOP #############

mov ecx, 0
_wordCounter:
mov ah, [input_buffer + ecx]
inc ecx
cmp ah, 13
je _endwordCounter
cmp ah, 32
jne _wordCounter
inc edx
jmp _wordCounter
_endwordCounter:
;; end of digit
xor eax, eax
xor ebx, ebx
xor ecx, ecx
inc edx
mov eax, edx
push 0 ;;push null to indicate string stop
_counterLoop3:
mov edx, 0
mov ecx, 10
div ecx
add edx, 48
push dword edx
cmp eax, 0
jne _counterLoop3
;; here counting loop ends and printing stars
;; it all works using stack, to reverse order
pusha
push dword 0
push dword actually_wrote
push dword sizenow
push dword now
push dword [write_handle]
call [WriteFile]
popa
_printerLoop3:
;; get from stack
lea ebx, [esp]
cmp dword [ebx], 00
je _stopPrint3 ;; stop print if null on stack
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
jmp _printerLoop3

_stopPrint3: 
push 10;; print new line for clearance
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
xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx

;############### SENTENCE LOOP #############

mov ecx, 0
_sentenceCounter:
mov ah, [input_buffer + ecx]
inc ecx
cmp ah, 13
je _endsentenceCounter
cmp ah, 46
jne _sentenceCounter
inc edx
jmp _sentenceCounter
_endsentenceCounter:
;; end of digit
xor eax, eax
xor ebx, ebx
xor ecx, ecx
; inc edx
mov eax, edx
push 0 ;;push null to indicate string stop
_counterLoop4:
mov edx, 0
mov ecx, 10
div ecx
add edx, 48
push dword edx
cmp eax, 0
jne _counterLoop4
;; here counting loop ends and printing stars
;; it all works using stack, to reverse order
pusha
push dword 0
push dword actually_wrote
push dword sizenos
push dword nos
push dword [write_handle]
call [WriteFile]
popa
_printerLoop4:
;; get from stack
lea ebx, [esp]
cmp dword [ebx], 00
je _stopPrint4 ;; stop print if null on stack
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
jmp _printerLoop4

_stopPrint4: 
push 10;; print new line for clearance
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
xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx

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
nol db "Number of letters is: ", 0
sizenol equ $ - nol - 1
nod db "Number of digits is: ", 0
sizenod equ $ - nod - 1
now db "Number of words is: ", 0
sizenow equ $ - now - 1
nos db "Number of sentences is: ", 0
sizenos equ $ - nos - 1
size2 equ 1
zerolen db 13

section .bss
write_handle resd 1
read_handle resd 1
actually_wrote resd 1
input_buffer resb input_buffer_size
actually_read resd 1