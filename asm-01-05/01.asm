;; tutaj deklarujemy nazwy funkcji ze zewnętrznych bibliotek,
;; które będą wykorzystywane w programie
;; jest to faktycznie taki #include czy import

;; czyli najpierw informujemy kompilator, że funkcje o takich nazwach będą pobrane z zewnątrz
;; w zasadzie, to pobrane zostaną adresy funkcji -- miejsca, w których te funkcje znajduję się w pamięci
extern AllocConsole
extern FreeConsole
extern GetStdHandle
extern WriteFile
extern Sleep
extern ExitProcess

;; a tutaj wskazujemy, z jakiej biblioteki dll należy je pobrać (kernel32 jest już w systemie Windows)
import AllocConsole kernel32.dll
import FreeConsole kernel32.dll
import GetStdHandle kernel32.dll
import WriteFile kernel32.dll
import Sleep kernel32.dll
import ExitProcess kernel32.dll

;;;;;;;;;;;;;;;;;;;;
;; sekcje z kodem ;;
;;;;;;;;;;;;;;;;;;;;

;; sekcja text -- tutaj znajduje się kod
section .text use32

..start: ;; tutaj zaczyna się program

;; wywołujemy pierwszą funkcję, akurat bez argumentu
call [AllocConsole] ;; tworzenie okna (konsoli)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; wyświetlanie komunikatu ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; pobieramy tzw. uchwyt do konsoli, który następnie zostanie wykorzystany do wyświetlenia komunikatu
;; najpierw przekazujemy argument funkcji [GetStdHandle] na stos, jest tylko jeden
push dword -11 ;; -11 to wartość, która pozwoli pozyskać uchwyt do konsoli na potrzeby >wyświetlania<
call [GetStdHandle] ;; wywołujemy funkcję
;; funkcja zwróciła wartość do rejestru eax, tam znajduje się uchwyt, musimy go skopiować w jakieś bezpieczne miejsce pamięci
mov dword [uchwyt_wyjscia], eax ;; robimy to tutaj, czyli z eax przenosimy wartość pod ADRES uchwyt_wyjscia; adres wskazujemy przez [...]

;; teraz wyświetlamy komunikat; funkcja wyświetlająca bierze 5 argumentów; wszystkie podajemy na stos
push dword 0 ;; pusty parametr funkcji -- pomijany
push dword rozmiar_wyjscia ;; ile bajtów udało się wyświetlić (pod ten adresu procedura zwróci wartość)
	;; nie korzystamy z tej wartości, ale jest to wymagany argument
push dword rozmiar ;; rozmiar komunikatu
push dword komunikat ;; adres komunikatu
push dword [uchwyt_wyjscia] ;; przekazujemy uchwyt do konsoli, do >wyświetlania<
call [WriteFile] ;; wyświetlamy do wirtualnego pliku, czyli tutaj do konsoli

;;;;;;;;;;;;;;;;;;
;; koniec pracy ;;
;;;;;;;;;;;;;;;;;;

;; czekamy 2 sekundy i zamykamy okno konsoli
push dword 2000
call [Sleep] ;; pauza
call [FreeConsole] ;; zamknięcie konsoli
xor eax, eax ;; zerujemy eax
push eax ;; przekazujemy parametr procedury: kod błędu (jeśli 0, to nie było błędu)
call [ExitProcess] ;; koniec procesu

;;;;;;;;;;;;;;;;;;;;;
;; sekcje z danymi ;;
;;;;;;;;;;;;;;;;;;;;;

;; sekcja z danymi z wartościami początkowymi
section .data
komunikat db "Hello world.", 13, 10, 0 ;; znaki 13 i 10 to ekwiwalent entera, a wartość 0 kończy tekst
rozmiar equ $ - komunikat - 1 ;; tutaj wyznaczamy długość komunikatu; $ to wartość aktualnej pozycji w kodzie
	;; (czyli akurat koniec ciągu "Hello world.", 13, 10, 0)

;; sekcja z danymi bez wartości początkowych
section .bss
uchwyt_wyjscia resd 1
rozmiar_wyjscia resd 1

;; resd 1 - rezerwuj jedno podwójne słowo (4 bajty)
;; podobnie mamy
;; resb -- bajt
;; resw -- słowo