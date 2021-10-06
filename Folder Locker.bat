:: [05/01/2019 - 23:30]
@Echo off
@Setlocal enabledelayedexpansion

for /f "delims=#" %%a in ('"prompt #$H# & for %%b in (1) do rem"') do (set "bs=%%a")
set "color=call :color"
set "DataFol=%ProgramData%\CryptnetCache"
set "LockFolder=cacls "%ProgramData%\CryptnetCache" /e /c /p "%username%":N 2>&1 >nul"
set "UnlockFolder=cacls "%ProgramData%\CryptnetCache" /e /c /p "%username%":F 2>&1 >nul"
md "%DataFol%" "%temp%" 2>nul
%LockFolder%

::------------ Interface ------------::
@Mode 72,16
@Title Folder Locker  ^|  By Psi505 (c) 2020
color 1e
echo.
echo. :=------------------------------------------------------------------=:
echo.
echo.      _____     _     _              _               _
echo.     ^|  ___^|__ ^| ^| __^| ^| ___ _ __   ^| ^|    ___   ___^| ^| _____ _ __
echo.     ^| ^|_ / _ \^| ^|/ _` ^|/ _ \ '__^|  ^| ^|   / _ \ / __^| ^|/ / _ \ '__^|
echo.     ^|  _^| (_) ^| ^| (_^| ^|  __/ ^|     ^| ^|__^| (_) ^| (__^|   ^<  __/ ^|
echo.     ^|_^|  \___/^|_^|\__,_^|\___^|_^|     ^|_____\___/ \___^|_^|\_\___^|_^|
echo.
echo.
echo.
echo.                            Author  : Psi505
echo.                            Version : 1.1
echo.
echo. :=------------------------------------------------------------------=:
pause>nul
::-----------------------------------::

::--------------- Menu --------------::
:Menu
    cls
    @Mode 66,17
    @Title Folder Locker
    color 7
    echo.
    echo          Hi %username%  Welcome to my program  ^^_^^
    echo.
    echo.
    %color% 0b "  Choose an option :" /n
    echo.  ------------------
    echo.
    %color% 0e "   1 "
    echo - Lock a new folder
    %color% 0e "   2 "
    echo - Unlock a folder
    echo.
    %color% 0c "   0 "
    echo - Exit
    echo.
    echo.
    %color% 0c "  Note :"
    echo. don't use ^| or ^& in your passwords (they make problems)
    echo.
    echo.
    choice /n /c 120 /m "> " & cls
    if %errorlevel%==3 (exit)
    call :Opt-%errorlevel%
Exit
::-----------------------------------::


::------------- Options -------------::
:Opt-1
    @mode 56,8
    @title Lock
    :Get-FolderNameTL
        cls & color 7
        echo Enter the folder's name / Drag the folder here :
        set /p "FNTL=> "
    if not defined FNTL (goto Get-FolderNameTL)
    set "FNTL=%FNTL:"=%"
    
    :: test the the given name type & check its existance
    set "type=NotExist"
    if exist "%FNTL%" (dir /ad "%FNTL%" 1>nul 2>nul && set "type=Folder" || set "type=File")
    if "%type%"=="NotExist" (
        color c
        echo.
        echo.
        echo              Can't find this folder -_-
        echo.
        pathping 127.0.0.1 -n -q 1 -p 2000 >nul
        goto Get-FolderNameTL
    )
    if "%type%"=="File" (
        color c
        echo.
        echo.
        echo                That's not a folder -_-
        echo.
        pathping 127.0.0.1 -n -q 1 -p 2000 >nul
        goto Get-FolderNameTL
    )

    :: Get the folder's name only    
    for /f "skip=2 tokens=*" %%i in ('tree "%FNTL%"') do (set "FNL=%%~ni" & goto ExFor)
    :ExFor
    %UnlockFolder%

    if exist "%DataFol%\%FNL%" (
        color c
        echo.
        echo.
        echo    This folder has the same name of a locked one -_-
        echo.
        pathping 127.0.0.1 -n -q 1 -p 3800 >nul
        %LockFolder%
        goto Get-FolderNameTL
    )

    :Get-PassTL
        cls & color 7
        echo Enter a password to lock your folder :
        call :Password Passw
        cls
        echo Enter the password again :
        call :Password _Passw
        if not "%Passw%"=="%_Passw%" (
            color c
            echo.
            echo.
            echo                  Wrong password -_-
            echo.
            pathping 127.0.0.1 -n -q 1 -p 1700 >nul
            goto Get-PassTL
        )
    if not defined Passw (goto Get-PassTL) else (
        %UnlockFolder%
        echo.!FNL!^|^|%Passw%>>"%DataFol%\FolsPaswrds.db"
    )
    move "%FNTL%" "%DataFol%" 1>nul
    set /p="This folder is locked" <nul >"%FNTL%"

    :: End of tasks
    %LockFolder%
    @mode 43,6
    cls & color a
    echo.
    echo.   Your folder is protected now ^^_-
    echo.
    echo.   I hope that my program helps you *_*
    echo.
    pause>nul
Exit /b



:Opt-2
    :: Check the existance of locked folders
    @mode 56,5
    @title Unlock
    %UnlockFolder%
    if not exist "%DataFol%\FolsPaswrds.db" (
        color c
        echo.
        echo.
        echo            There is no locked folder yet ?_?
        echo.
        pathping 127.0.0.1 -n -q 1 -p 2700 >nul
        %LockFolder%
        goto Menu
    )

    %LockFolder%
    @mode 56,8
    :Get-FolderNameTU
        cls & color 7
        echo Enter the folder's name / Drag the locked folder here :
        set /p "FNTU=> "
    if not defined FNTU (goto Get-FolderNameTU)
    set "FNTU=%FNTU:"=%"
    
    :: test the the given name type - check its existance - Get the folder's name only
    if exist "%FNTU%" (dir /ad "%FNTU%" 1>nul 2>nul && set "type=Folder" || set "type=File")
    if exist "%FNTU%"  if "%type%"=="File" (
        for /f "skip=2 tokens=*" %%i in ('tree "%FNTU%"') do (
            set "FNU=%%~ni"
            set "dp=%%~dpi"
            goto ExFor2
        )
    ) else (
        color c
        echo.
        echo.
        echo          This is not a locked folder -_-
        echo.
        pathping 127.0.0.1 -n -q 1 -p 2000 >nul
        goto Get-FolderNameTU
    )
    :ExFor2    

    if defined FNU (set "FNTU=%FNU%") else (set "dp=%cd%")
    %UnlockFolder%
    if not exist "%DataFol%\%FNTU%" (
        color c
        echo.
        echo.
        echo        This folder is not locked before -_-
        echo.
        pathping 127.0.0.1 -n -q 1 -p 2500 >nul
        %LockFolder%
        goto Get-FolderNameTU
    )

    :Get-PassTU
        %LockFolder%
        cls & color 7
        echo Enter the password to unlock your folder :
        call :Password UPassw
    if not Defined UPassw (goto Get-PassTU)
    
    :: Check if the password exist in the data file or not
    %UnlockFolder%
    for /f "tokens=*" %%i in ('type "%DataFol%\FolsPaswrds.db"') do (
        if "%%i"=="%FNTU%||%UPassw%" (
            del "%FNTU%" 2>nul
            move "%DataFol%\%FNTU%" "%dp%" 1>nul
            goto ValidPassw
        )
    )
    color c
    echo.
    echo.
    echo                  Wrong password -_-
    echo.
    pathping 127.0.0.1 -n -q 1 -p 1800 >nul
    goto Get-PassTU
    :ValidPassw

    :: Remove the password from the data file
    for /f "tokens=*" %%i in ('type "%DataFol%\FolsPaswrds.db"') do (
        if not "%%i"=="%FNTU%||%UPassw%" (echo.%%i>>"%Temp%\FolsPaswrds.db")
    )
    if not exist "%Temp%\FolsPaswrds.db" (
        del "%DataFol%\FolsPaswrds.db"
        rd "%DataFol%"
    ) else (
        move /y "%Temp%\FolsPaswrds.db" "%DataFol%"
    )

    :: End of tasks
    %LockFolder%
    @mode 43,6
    cls & color a
    echo.
    echo.   Your folder is unlocked now ^^_-
    echo.
    echo.   I hope that my program helps you *_*
    echo.
    pause>nul
Exit /b
::-----------------------------------::


::----------- Extra Funcs -----------::
:Password
    :: Encrypt the password in the input with '*' using powershell commands
    set /p="> " < nul
    for /f "tokens=*" %%i in (
        'powershell -command "$pass=Read-Host -ASS;$BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass);$upass=[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR);$upass"'
    ) do (set "pass=%%i")
    set "%1=!pass!"
Exit /b

:color
    set /p="." <nul >-
    set "msg=^%~2" !
    findstr /p /a:%1 "." "%msg%\..\-" nul
    set /p="%bs%%bs%%bs%%bs%%bs%%bs%%bs%" <nul
    if "%~3"=="/n" (echo.)
    del -
Exit /b
::-----------------------------------::