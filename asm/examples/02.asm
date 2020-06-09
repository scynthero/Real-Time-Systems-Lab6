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
id_uchwyt_zapisu equ -11 ;; ta wartość, przekazywana jako argument funkcji [GetStdHandle]
  ;; pozwoli uzyskać uchwyt do konsoli, do zapisu
id_uchwyt_odczytu equ -10 ;; ta wartość pozwoli uzyskać uchwyt do konsoli, do odczytu
  ;; tak, to są dwie różne wartości
rozmiar_bufora_wejscia equ 50 ;; maksymalnie 50 bajtów będzie mógł mieć komunikat podawany przez użytkownika

section .text use32 ;; kod programu

..start:
call [AllocConsole] ;; tworzenie konsoli
push dword tytul 
call [SetConsoleTitleA] ;; ustawianie tytułu

;; pobieranie uchwytów
push dword id_uchwyt_zapisu
call [GetStdHandle]
mov dword [uchwyt_zapisu], eax
push dword id_uchwyt_odczytu
call [GetStdHandle]
mov dword [uchwyt_odczytu], eax

;; wyświetlanie komunikatu msg1
push dword 0
push dword ile_faktycznie_wyswietlono
push dword size1
push dword msg1
push dword [uchwyt_zapisu]
call [WriteFile]

;; odczytwanie komunikatu wpisanego przez użytkownika
push dword 0
push dword ile_faktycznie_odczytano ;; tutaj dostaniemy informację zwrotną: ile bajtów (znaków) użytkownik faktycznie wpisał
  ;; z tej informacji korzystamy, gdy wyświetlamy użytkownikowi jego własny komunikat
push dword rozmiar_bufora_wejscia ;; maksymalny rozmiar komunikatu
push dword bufor_wejscia ;; tutaj, czyli pod adresem bufor_wejscia, funkcja [ReadFile] zwróci wpisany komunikat
push dword [uchwyt_odczytu] ;; przekazujemy uchwyt do konsoli do >odczytu<
call [ReadFile]

;; wyświetlanie komunikatu msg2
push dword 0
push dword ile_faktycznie_wyswietlono
push dword size2
push dword msg2
push dword [uchwyt_zapisu]
call [WriteFile]

;; wyświetlanie wcześniej wpisanego komunikatu
push dword 0
push dword ile_faktycznie_wyswietlono ;; ile bajtów wyświetlono
push dword [ile_faktycznie_odczytano] ;; ile bajtów mamy wyświetlić znajduje się pod >adresem< ile_faktycznie_odczytano
push dword bufor_wejscia ;; do bufor_wejscia zapisaliśmy komunikat, który użytkownik wcześniej wpisał
push dword [uchwyt_zapisu]
call [WriteFile]

;; komunikat końcowy
push dword 0
push dword ile_faktycznie_wyswietlono
push dword size3
push dword msg3
push dword [uchwyt_zapisu]
call [WriteFile]

;; pauza i zakończenie pracy
push dword 2000
call [Sleep]
call [FreeConsole] 
xor eax, eax
push eax
call [ExitProcess]

section .data ;; dane programu
tytul db "Tytul aplikacji", 0
msg1 db "Napisz cos: ", 0
size1 equ $ - msg1 - 1
msg2 db "Napisane zostalo: ", 0
size2 equ $ - msg2 - 1
msg3 db "Pozdrawiam.", 13, 10, 0
size3 equ $ - msg3 - 1

section .bss
uchwyt_zapisu resd 1
uchwyt_odczytu resd 1
ile_faktycznie_wyswietlono resd 1
bufor_wejscia resb rozmiar_bufora_wejscia
ile_faktycznie_odczytano resd 1