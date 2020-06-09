;; funkcje z bibliotek
extern MessageBoxA
extern ExitProcess

import MessageBoxA user32.dll
import ExitProcess kernel32.dll

section .text use32 ;; kod programu

..start:

;; procedura do wyświetlania okienka bierze 4 argumenty
push dword 0
push dword tytul
push dword komunikat
push dword 0 ;; typ okna
call [MessageBoxA]

;; koniec programu
push dword 0
call [ExitProcess]

section .data ;; dane
tytul db "Tytul okna", 0
komunikat db "Komunikat w oknie", 0