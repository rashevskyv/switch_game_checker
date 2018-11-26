@echo off

echo ------------------------------------------------------------------------
echo.
echo        %~nx1
echo.
echo ------------------------------------------------------------------------
echo.

::search for script-path
for /f "delims=" %%i in ("%0") do set "curpath=%%~dpi"
chdir /d %curpath%
set tempdir_game=temp

if not exist hactool.exe (
echo ---------------------------------------------------------------------------
echo.
COLOR 4
echo                     hactool.exe DID NOT FOUND!
echo.
echo       please poot hactool.exe in the same folder with this script
echo                        and run script again!
echo.
echo Download hactool here: https://github.com/SciresM/hactool/releases/latest
echo.
echo ---------------------------------------------------------------------------
echo.
pause
exit
)

::check keys
if not exist keys.txt (
COLOR 4
echo.
echo.
echo Get your keys first! Use kezplez on Switch or google it!
echo.
echo.
pause
exit
)

::make temp directory
if not exist %tempdir_game% (mkdir %tempdir_game%)

echo * Unpacking of %~nx1, please wait!
echo    - Programm is not freezing. Be patient!

::looking for filetype
if "%~x1" == ".nsp" (hactool.exe %1 -k keys.txt -x --intype=pfs0 --pfs0dir=%tempdir_game% >%~n1.errorlog) else (
if "%~x1" == ".xci" (hactool.exe %1 -txci --securedir=%tempdir_game% >%~n1.errorlog) else (

cls
echo %~nx1:
echo.
echo ------------------------------------------------------------------------
echo.
COLOR 4
echo                           WRONG FILE TYPE!
echo.
echo              script works only with XCI and NSP files!
echo.
echo ------------------------------------------------------------------------
echo.

goto :end
)
)

echo    - DONE
echo.

::looking for ncas in tempdir
dir %tempdir_game% /s/a-d >nul
IF ERRORLEVEL 1 (

cls
echo %~nx1:
echo.
echo ------------------------------------------------------------------------
echo.
COLOR 4
echo                           SOMETHING GONE WRONG!
echo.
echo           file is not Switch game or contain forbidden symbols
echo        rename your game file only with latin symbols and numbers!
echo.
echo ------------------------------------------------------------------------
echo.

goto :end
)

::looking for biggest nca
(for /f "delims=" %%i in ('dir %tempdir_game% /b /os') do set nca_file=%%~nxi)>nul

echo * Checking of %nca_file%, please wait!
echo    - Programm is not freezing. Be patient!

::verify biggest nca
hactool.exe -k keys.txt -y %tempdir_game%/%nca_file% >>check.log
echo    - DONE
echo.

::check log for result
findstr  /i /c:"Fixed-Key Signature (GOOD)" check.log>NUL
IF ERRORLEVEL 1 (
cls
echo.
echo ------------------------------------------------------------------------
echo.
COLOR 4
echo              %~nx1 IS CORRUPTED!
echo.
echo ------------------------------------------------------------------------
set filename=md5/BAD_%~nx1
del /q %~n1.errorlog >nul 2>&1

) ELSE (
cls
echo.
echo ------------------------------------------------------------------------
echo.
COLOR 2
echo              %~nx1 IS GOOD
echo.
echo ------------------------------------------------------------------------
echo.
set filename=md5/GOOD_%~nx1
del /q %~n1.errorlog >nul 2>&1

)

::md5 stuff

if not exist md5 (mkdir md5)


::check windows version
systeminfo | findstr /C:"Windows 10" /C:"Windows 8" >nul
IF ERRORLEVEL 1 (

chdir /d %curpath%

::check for fciv in win<10
if not exist fciv.exe (

Powershell.exe -command "(New-Object System.Net.WebClient).DownloadFile('http://customfw.xyz/switch_game_checker/fciv.exe','fciv.exe')
)

echo Calculating md5, please wait!
fciv -md5 "%1" > %filename%.md5
echo|set /p="MD5: "
for /f "skip=1" %%a in (%filename%.md5) do echo %%a >> 1.txt
tail -1 1.txt
del 1.txt
echo.

) else  (

echo Calculating md5, please wait!
certUtil -hashfile "%1" md5 > %filename%.md5
echo|set /p="MD5: "
tail -2 %filename%.md5 | head -1
echo.
)

::remove tempfiles and end
:end
rmdir /Q /S %tempdir_game% >nul 2>&1
del /q check.log >nul 2>&1

pause