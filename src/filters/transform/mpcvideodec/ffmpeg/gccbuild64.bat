@echo off
if NOT "x%MINGW64%" == "x" goto Var1Ok
echo "ERROR : please define MINGW64 (and/or MSYS) environment variable(s)"
exit 1005

:Var1Ok
if NOT "x%CC%" == "x" goto Var2Ok
echo "ERROR : please define CC environment variable"
exit 1005

:Var2Ok
set PATH=%MSYS%\bin;%YASM%;%MINGW64%\bin;%PATH%
IF EXIST "%MINGW32%\bin\mingw32-make.exe" copy /y "%MINGW32%\bin\mingw32-make.exe" "%MINGW32%\bin\make.exe" >nul
IF EXIST "%MINGW64%\x86_64-w64-mingw32\bin\ar.exe" copy /y "%MINGW64%\x86_64-w64-mingw32\bin\ar.exe" "%MINGW64%\bin\x86_64-w64-mingw32-ar.exe" >nul
IF EXIST "%MINGW64%\bin\x86_64-w64-mingw32-make.exe" copy /y "%MINGW64%\bin\x86_64-w64-mingw32-make.exe" "%MINGW64%\bin\make.exe" >nul
IF EXIST "%MINGW64%\x86_64-w64-mingw32\bin\gcc.exe" copy /y "%MINGW64%\x86_64-w64-mingw32\bin\gcc.exe" "%MINGW64%\bin\x86_64-w64-mingw32-gcc.exe" >nul

IF "%1%"=="rebuild" goto DoClean
IF "%1%"=="clean" goto OnlyClean
goto NoClean

:OnlyClean
make.exe 64BIT=yes clean
IF EXIST 32bit.build rm 32bit.build
goto End

:DoClean
make.exe 64BIT=yes clean
IF EXIST 32bit.build rm 32bit.build

:NoClean
IF NOT EXIST 32bit.build GOTO NoArchClean
make.exe 64BIT=yes clean
rm 32bit.build

:NoArchClean
touch 64bit.build
make.exe 64BIT=yes -j8

:End
