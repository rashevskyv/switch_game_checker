rem @echo off
chcp 65001 

::search for script-path
for /f "delims=" %%i in ("%0") do set "curpath=%%~dpi"
chdir /d %curpath%
set tempdir_game=temp

del temp.log

::process names with exact program launch and dragging game to it
::look for argument; coma if two arguments; no_coma if one; launching if script was launched by double click
if "%~1" neq "" (
	@if "%~2" neq "" (
		goto :coma
	) else (
		goto :no_coma
)) else (
	goto :launching
)
	
:launching
echo Drag and Drop here your GAME NSP, then press Enter: 
set /p game=""
echo %game%>temp.log
goto :main
	
:no_coma
set game=%~1
echo %game%>>temp.log	
goto :main

:coma
echo %1>>temp.log
echo ,>>temp.log
echo %2>>temp.log
set "t="
for /f "tokens=* delims=" %%i in (temp.log) do (<nul set /p s=%%i%t%>>temp1.log)
type temp1.log>temp.log
del temp1.log
goto :main

:main 
::set vars, delete spaces and comas from filename. There is fuckng dirty code. I do not know how and why it work O_O
For /F "tokens=* delims=" %%A In (temp.log) Do (

    Set gamepath=%%~dpA
	Set gametype=%%~xA
	Set gamename=%%~nA
	Set gamenshort=%%~fsA
	SET str=%%~nA.errorlog > temp.log
)
::get first 4 symbols from gametype
	Set gametype=%gametype:~0,4%
    Set gamenametype=%gamename%%gametype%
	Set fullpath=%gamepath%%gamenametype%
	echo.%gamenametype%

	FOR /F "usebackq delims=" %%i IN (temp.log) DO (Set "Without=%%i" & Echo !Without: =!)
	set errorlog=%str: =%
	set errorlog=%errorlog:,=%

	echo %errorlog% > temp.log
	
	tail -1 temp.log > %errorlog% >nul 2>&1
	

	echo %fullpath%
    echo %gamepath%
    echo %gamenametype%>gntype.txt
	echo %gametype%>gtype.txt
	echo %gamename%
	echo %gamenshort%
	echo %str%
	
For /F "tokens=* delims=" %%U In (temp.log) Do (set md5=%%~nU.md5)

::process names when user dragging game to bat
echo ------------------------------------------------------------------------
echo.
echo        %gamenametype%
echo.
echo ------------------------------------------------------------------------
echo.

::remove file from previous iteration
rmdir /Q /S %tempdir_game% >nul 2>&1
del /q check.log >nul 2>&1
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

echo * Unpacking of %gamenametype%, please wait!
echo    - Programm is not freezing. Be patient!

::looking for filetype
chdir /d %curpath%
if "%gametype%" == ".nsp" (hactool.exe "%fullpath%" -k keys.txt -x --intype=pfs0 --pfs0dir=%tempdir_game% > %errorlog%) else (
if "%gametype%" == ".xci" (hactool.exe "%fullpath%" -txci --securedir=%tempdir_game% > %errorlog%) else (


rem cls
echo %gamenametype%:
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

rem cls
echo %gamenametype%:
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
rem cls
echo.
echo ------------------------------------------------------------------------
echo.
COLOR 4
echo              %gamenametype% IS CORRUPTED!
echo.
echo ------------------------------------------------------------------------
set md5name=md5/BAD_%md5%
del /q %errorlog% >nul 2>&1

) ELSE (
rem cls
echo.
echo ------------------------------------------------------------------------
echo.
COLOR 2
echo              %gamenametype% IS GOOD
echo.
echo ------------------------------------------------------------------------
echo.
set md5name=md5/GOOD_%md5%
del /q %errorlog% >nul 2>&1

)

::md5 stuff

if not exist md5 (mkdir md5)


::check windows version
systeminfo | findstr /C:"Windows 8" /C:"Windows 10" >nul
IF ERRORLEVEL 1 (

chdir /d %curpath%

::check for fciv in win<10
if not exist fciv.exe (

Powershell.exe -command "(New-Object System.Net.WebClient).DownloadFile('http://customfw.xyz/switch_game_checker/fciv.exe','fciv.exe')
)

echo Calculating md5, please wait!
fciv -md5 %game% > %md5name%
echo|set /p="MD5: "
for /f "skip=1" %%a in (%md5name%) do echo %%a >> temp.log
tail -1 temp.log
del temp.log
echo.

) else  (

echo Calculating md5, please wait!
certUtil -hashfile %game% md5 > %md5name%
echo|set /p="MD5: "
tail -2 %md5name% | head -1
echo.
)

::remove tempfiles and end
:end
rmdir /Q /S %tempdir_game% >nul 2>&1
del /q check.log >nul 2>&1

pause