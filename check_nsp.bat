@echo off

echo ------------------------------------------------------------------------
echo.
echo        %~n1
echo.
echo ------------------------------------------------------------------------

set tempdir_game=temp

for /f "delims=" %%i in ("%0") do set "curpath=%%~dpi"
chdir /d %curpath%

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

echo * Unpacking of %~n1, please wait!
echo    - Programm is not freezing. Be patient!
<<<<<<< HEAD
echo    (�ணࠬ�� �� ����᫠, � �ᯠ���뢠�� ����)
=======
echo    (программа не зависла, а распаковывает игру)
>>>>>>> 2e0a8c163e1d286f153a87e709a44734949d8b05

if not exist %tempdir_game% (mkdir %tempdir_game%)

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
echo                            ЧТО-ТО ПОШЛО НЕ ТАК!
echo.
echo     файл не является игрой на Switch или содержит запрещённые символы
echo                  переименуйте игру так, чтобы она содержала
echo                     только латинские символы и цифры!
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
echo.
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

systeminfo | findstr /C:"Windows 10" >nul
IF ERRORLEVEL 1 (

for /f "delims=" %%i in ("%0") do set "curpath=%%~dpi"
chdir /d %curpath%

if not exist fciv.exe (

Powershell.exe -command "(New-Object System.Net.WebClient).DownloadFile('http://customfw.xyz/switch_game_checker/fciv.exe','fciv.exe')
)

echo Calculating md5, please wait!
if exist %~n1.md5 (del %~n1.md5)
fciv -md5 "%1" >> %~n1.md5
echo|set /p="MD5: "
for /f "skip=1" %%a in (%~n1.md5) do echo %%a >> 1.txt
tail -1 1.txt
del 1.txt
echo.

) else  (

echo Calculating md5, please wait!
if exist %~n1.md5 (del %~n1.md5)
certUtil -hashfile "%1" md5 >> %~n1.md5
echo|set /p="MD5: "
tail -2 %~n1.md5 | head -1
echo.

	)
)

:end
rmdir /Q /S %tempdir_game% >nul 2>&1
del /q check.log >nul 2>&1
echo.
<<<<<<< HEAD
pause
=======
pause
>>>>>>> 2e0a8c163e1d286f153a87e709a44734949d8b05
