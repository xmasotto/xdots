@echo off
set MSYS=winsymlinks:native
set MSYSTEM=MINGW32
call C:\Users\xmasotto\.startup.bat

chdir C:\msys64
if "%INSIDE_EMACS%"=="" usr\bin\mkgroup -c > etc/group
usr\bin\bash --login -i