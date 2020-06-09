for %%f in (*.asm) do (
nasm -fobj "%%~nf.asm"
alink -oPE "%%~nf.obj"
del "%%~nf.obj"
)
