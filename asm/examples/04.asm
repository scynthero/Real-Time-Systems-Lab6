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
id_uchwyt_wyjscia equ -11
id_uchwyt_wejscia equ -10
maksymalny_rozmiar_wejscia equ 50

section .text use32

..start:
;; konsola/okno
call [AllocConsole]
push dword tytul
call [SetConsoleTitleA]

;; uchwyty
push dword id_uchwyt_wyjscia
call [GetStdHandle]
mov dword [uchwyt_wyjscia], eax
push dword id_uchwyt_wejscia
call [GetStdHandle]
mov dword [uchwyt_wejscia], eax

startloop: ;; początek pętli
;; wyświetlamy komunikat
push dword 0
push dword rozmiar_wyjscia
push dword size1
push dword msg1
push dword [uchwyt_wyjscia]
call [WriteFile]

;; pobieramy komunikat
push dword 0
push dword rozmiar_wejscia
push dword maksymalny_rozmiar_wejscia
push dword bufor_wejscia
push dword [uchwyt_wejscia]
call [ReadFile]

;; weryfikujemy, czy komunikat to T
push eax ;; kopiujemy eax na stos (żeby nie stracić wartości, chociaż akurat w tym programie to niepotrzebne)
mov ah, byte [bufor_wejscia] ;; przenosimy pierwszy bajt z adresu bufor_wejscia do AH
cmp ah, byte [tak1] ;; porównujemy wartość AH z wartością z adresu tak1
pop eax ;; zwracamy eax ze stosu
je endloop ;; jeśli porównywanie zakończyło się równością, to skaczemy do etykiety endloop

;; analogicznie dla t
push eax
mov ah, byte [bufor_wejscia]
cmp ah, byte [tak2]
pop eax
je endloop

jmp startloop ;; wracamy do etykiety startloop
endloop: ;; koniec pętli

;; koniec programu
call [FreeConsole] 
xor eax, eax
push eax
call [ExitProcess]

section .data ;; dane programu
tytul db "App 04", 0
msg1 db "Wpisz T/t aby zakonczyc program.", 13, 10, ">> ", 0
size1 equ $ - msg1 - 1
tak1 db 13
tak2 db "t"

section .bss
uchwyt_wyjscia resd 1
uchwyt_wejscia resd 1
rozmiar_wyjscia resd 1
bufor_wejscia resb maksymalny_rozmiar_wejscia
rozmiar_wejscia resd 1