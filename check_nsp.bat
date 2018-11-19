@echo off

echo ------------------------------------------------------------------------
echo.
echo        %~n1
echo.
echo ------------------------------------------------------------------------

echo * Unpacking of %~n1, please wait!
echo    - Programm is not freezing. Be patient!

set tempdir_game=temp
Set url=https://pastebin.com/raw/GQesC1bj
Set keys=keys.txt

for /f "delims=" %%i in ("%0") do set "curpath=%%~dpi"
chdir /d %curpath%

if not exist %tempdir_game% (mkdir %tempdir_game%)
if not exist %keys% (Powershell.exe -command "(New-Object System.Net.WebClient).DownloadFile('%url%','%keys%')")

if "%~x1" == ".nsp" (hactool.exe %1 -k keys.txt -x --intype=pfs0 --pfs0dir=%tempdir_game% >nul 2>&1
) else (hactool.exe %1 -k keys.txt -txci --securedir=%tempdir_game% >nul 2>&1)

echo    - DONE
echo.

dir %tempdir_game% /s/a-d >nul
IF ERRORLEVEL 1 (

cls
echo.
echo ------------------------------------------------------------------------
echo.
COLOR 4
echo                           SOMETHING GONE WRONG!
echo.
echo           file is not Switch game or contain forbidden symbols
echo      rename your game file to simple name without , ' [ ] or others
echo.
echo ------------------------------------------------------------------------
echo.
echo                            —’-’ ˜‹ … ’€Š!
echo.
echo     ä ©« ­¥ ï¢«ï¥âáï ¨£à®© ­  Switch ¨«¨ á®¤¥à¦¨â § ¯à¥éñ­­ë¥ á¨¬¢®«ë
echo                  ¯¥à¥¨¬¥­ã©â¥ ¨£àã â ª, çâ®¡ë ®­  á®¤¥à¦ « 
echo                     â®«ìª® « â¨­áª¨¥ á¨¬¢®«ë ¨ æ¨äàë!
echo.
echo ------------------------------------------------------------------------
echo.

goto :end
)

(for /f "delims=" %%i in ('dir %tempdir_game% /b /os') do set nca_file=%%~nxi)>nul

hactool.exe -k keys.txt -y %tempdir_game%/%nca_file% >>check.log

findstr  /i /c:"Fixed-Key Signature (GOOD)" check.log>NUL
IF ERRORLEVEL 1 (
cls
echo.
echo ------------------------------------------------------------------------
echo.
COLOR 4
echo              %~n1 IS CORRUPTED!
echo.
echo ------------------------------------------------------------------------
) ELSE (
cls
echo.
echo ------------------------------------------------------------------------
echo.
COLOR 2
echo              %~n1 IS GOOD
echo.
echo ------------------------------------------------------------------------
)

:end
rmdir /Q /S %tempdir_game% >nul 2>&1
del /q check.log >nul 2>&1

pause