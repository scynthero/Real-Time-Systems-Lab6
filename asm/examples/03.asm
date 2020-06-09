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

section .text use32 ;; kod

..start:
call [AllocConsole]

push dword -11
call [GetStdHandle]
mov dword [uchwyt_wyjscia], eax

;; tutaj wyświetlamy komunikat msg1 o rozmiarze size1
;; korzystamy z własnej funkcji 'wyswietlacz'
push dword size1
push dword msg1
call wyswietlacz

;; komunikat msg2
push dword size2
push dword msg2
call wyswietlacz

;; komunikat msg3
push dword size3
push dword msg3
call wyswietlacz

;; pauza i koniec programu
push dword 2000
call [Sleep]
call [FreeConsole] 
xor eax, eax
push eax
call [ExitProcess]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; funkcja do wyświetlania ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wyswietlacz: ;; etykieta; pod nazwą 'wyswietlacz' znajduje się adres procedury
enter 0, 0 ;; tworzymy tzw. ramkę stosu, do przechowywania zmiennych lokalnych procedury (tutaj 0 zmiennych)

;; teraz wyświetlamy znanym już schematem
push dword 0 
push dword sizeoutput
push dword [ebp+12]
push dword [ebp+8]
push dword [uchwyt_wyjscia]
call [WriteFile]

;; kończymy procedurę
leave ;; niszczymy ramkę stosu
ret 8 ;; wracamy do miejsca, z którego funkcja została wywołana
  ;; jednocześnie zdejmując ze stosu 8 bajtów, czyli 2*4 bajty na 2 argumenty funkcji

;; koniec funkcji do wyświetlania 
  
section .data ;; dane programu
msg1 db "Pierwszy komunikat.", 13, 10, 0
size1 equ $ - msg1 - 1
msg2 db "Kolejny komunikat.", 13, 10, 0
size2 equ $ - msg2 - 1
msg3 db "Jeszcze jeden komunikat.", 13, 10, 0
size3 equ $ - msg3 - 1

section .bss
uchwyt_wyjscia resd 1
sizeoutput resd 1