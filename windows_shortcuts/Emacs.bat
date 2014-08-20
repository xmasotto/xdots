@echo off
chdir C:\msys64
set MSYSTEM=MINGW32
echo $HOME/.scripts/emacs --no-wait | usr\bin\bash --login