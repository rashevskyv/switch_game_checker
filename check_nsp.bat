@echo off

echo ------------------------------------------------------------------------
echo.
echo        %~n1
echo.
echo ------------------------------------------------------------------------

echo * Unpacking of %~n1, please wait!
echo    - Programm is not freezing. Be patient!
echo    (¯à®£à ¬¬  ­¥ § ¢¨á« ,   à á¯ ª®¢ë¢ ¥â ¨£àã)

set tempdir_game=temp
Set keys_url=https://pastebin.com/raw/GQesC1bj
Set keys=keys.txt

for /f "delims=" %%i in ("%0") do set "curpath=%%~dpi"
chdir /d %curpath%

if not exist %tempdir_game% (mkdir %tempdir_game%)
if not exist %keys% (Powershell.exe -command "(New-Object System.Net.WebClient).DownloadFile('%keys_url%','%keys%')")

if "%~x1" == ".nsp" (hactool.exe %1 -k keys.txt -x --intype=pfs0 --pfs0dir=%tempdir_game% >nul 2>&1
) else (if "%~x1" == ".xci" (hactool.exe %1 -k keys.txt -txci --securedir=%tempdir_game% >nul 2>&1)
else (

cls
echo %~n1%~x1:
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
echo                         ”€‰‹ …‚…ƒ ’ˆ€!
echo.
echo             áªà¨¯â à ¡®â ¥â â®«ìª® á XCI ¨ NSP ä ©« ¬¨!
echo.
echo ------------------------------------------------------------------------
echo.

goto :end
	)
)

echo    - DONE
echo.

dir %tempdir_game% /s/a-d >nul
IF ERRORLEVEL 1 (

cls
echo %~n1%~x1:
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
set filename=BAD_%~n1

) ELSE (
cls
echo.
echo ------------------------------------------------------------------------
echo.
COLOR 2
echo              %~n1 IS GOOD
echo.
echo ------------------------------------------------------------------------
echo.
set filename=GOOD_%~n1

)

systeminfo | findstr /C:"Windows 10" >nul
IF ERRORLEVEL 1 (

for /f "delims=" %%i in ("%0") do set "curpath=%%~dpi"
chdir /d %curpath%

if not exist fciv.exe (

Powershell.exe -command "(New-Object System.Net.WebClient).DownloadFile('http://customfw.xyz/switch_game_checker/fciv.exe','fciv.exe')
)

echo Calculating md5, please wait!
if exist %filename%.md5 (del %filename%.md5)
fciv -md5 "%1" >> %filename%.md5
echo|set /p="MD5: "
for /f "skip=1" %%a in (%filename%.md5) do echo %%a >> 1.txt
tail -1 1.txt
del 1.txt
echo.

) else  (

echo Calculating md5, please wait!
if exist %filename%.md5 (del %filename%.md5)
certUtil -hashfile "%1" md5 >> %filename%.md5
echo|set /p="MD5: "
tail -2 %filename%.md5 | head -1
echo.
)

:end
rmdir /Q /S %tempdir_game% >nul 2>&1
del /q check.log >nul 2>&1

pause