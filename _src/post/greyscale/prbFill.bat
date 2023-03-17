@echo off
rem 
rem @author Tyler R. Drury
rem @date 16-03-2023
rem @copyright Tyler R. Drury vigilance.eth, All Rights Reserved
rem @brief 
rem 
rem windows return codes
rem 0 success
rem 1 incorrect function has attempted to execute (not recognized op)
rem 2 system can not find a file in a specified location
rem 3 system can not find specified path
rem 5 access denied, use has no right to resource (use with authentication cli apps)
rem 0x2331 program not recognized as internal or external command, operable program or batch file
rem 0xC0000005 access violation(program terminated abnormally or crashed)
rem 0xC000013A terminated due to CTRL + C or CTRL + break
rem 0xC0000142 application failed to terminate properly
rem 
rem
if "%~1"=="" (
    if not defined _CLI_QUIET (
        echo %_DBG_PREFIX% Invalid argument count.
    )
    rem goto abortInvalidOp
    exit /B 1
)
rem 
if /I "%~1"=="--noig" goto setNOIG
rem 
call %GLOBAL_SCRIPTS%\idiognosis.bat bin sha256 ^
    "C:\_scripts\ssl-bat\input\sha256\%~n0" && ^
call %GLOBAL_SCRIPTS%\idiognosis.bat bin sha512 ^
    "C:\_scripts\ssl-bat\input\sha512\%~n0" || (
    echo [%~0] - external call to "idiognosis.bat bin" failed with error level: %ERRORLEVEL%
    exit /B %ERRORLEVEL%
)

REM call %GLOBAL_SCRIPTS%\idiognosis.bat hex sha256 ^
    REM "C:\_scripts\ssl-bat\input\x509\sha256\hex\%~n0-sha256.txt" && ^
REM call %GLOBAL_SCRIPTS%\idiognosis.bat hex sha512 ^
    REM "C:\_scripts\ssl-bat\input\x509\sha512\hex\%~n0-sha512.txt" || (
    REM echo [%~0] - external call to "idiognosis.bat hex" failed with error level: %ERRORLEVEL%
    REM exit /B %ERRORLEVEL%
REM )
rem 
rem call %GLOBAL_SCRIPTS%\idiognosis.bat base64 sha256 ^
rem     "C:\_scripts\ssl-bat\input\x509\sha256\base64\%~n0" &&
rem call %GLOBAL_SCRIPTS%\idiognosis.bat base64 sha512 ^
rem     "C:\_scripts\ssl-bat\input\x509\sha512\base64\%~n0" || (
rem     echo [%~0] - external call to "idiognosis.bat base64" failed with error level: %ERRORLEVEL%
rem     exit /B %ERRORLEVEL%
rem )
goto begin
rem 
REM for %%f in (
    REM C:\_scripts\argParse.bat
REM ) do (
    REM if not exist "%%f" (
        REM echo file does not exist @ "%%f"
        REM rem goto :exitFileNotFound
        REM exit /b 1
    REM )
REM )
rem
rem C:\_scripts\input\sha256\verifyBinFromFiles-sha256.txt
rem 
rem C:\_scripts\input\sha256\*.txt
rem C:\_scripts\input\sha256\verifyBinFromFiles-sha256.txt
rem C:\_scripts\input\sha256\argParse-sha256.txt
rem C:\_scripts\input\sha256\globals-sha256.txt
rem C:\_scripts\input\sha256\setErrorLevel-sha256.txt
rem C:\_scripts\input\sha256\safeDir-sha256.txt
REM for %%f in (
    REM C:\_scripts\input\sha256\argParse-sha256
REM ) do (
    REM rem call C:\_scripts\ssl-bat\_src\sha256\verifyBinFromFiles "%%~f"
    REM rem call C:\_scripts\ssl-bat\_src\sha256\verifyBinFromFiles.bat "%%~f.txt"
REM )
rem globals-sha256 argParse-sha256 || (
rem     exit /b %ERRORLEVEL%
rem )
rem C:\_scripts\input\sha512\*.txt
rem C:\_scripts\input\sha512\globals-sha512.txt
rem C:\_scripts\input\sha512\argParse-sha512.txt
rem C:\_scripts\input\sha512\verifyBinFromFiles-sha512.txt
rem C:\_scripts\input\sha512\*.txt
rem 
rem C:\_scripts\input\sha512\meta-sha512
rem C:\_scripts\input\sha512\globals-sha512.txt
REM for %%f in (
    REM C:\_scripts\input\sha512\argParse-sha512
REM ) do (
    REM rem call C:\_scripts\ssl-bat\_src\sha512\verifyBinFromFiles.bat "%%~f.txt"
REM )
rem globals-sha512 argParse-sha512 || (
rem     exit /b %ERRORLEVEL%
rem )
rem 
rem echo %*
rem 
rem exit /b 0
rem 
rem call C:\_scripts\argParse.bat --noig -init --encoding %* && call C:\_scripts\argParse.bat -init --digestalgo %*
rem call C:\_scripts\argParse.bat --noig -init %* || (
rem     echo initialization failed
rem     echo [%~0] - aborting script
rem     exit /b -1
rem )
rem 
:setNOIG
set "_CLI_NOIG=--noig"
set "_SCRIPT_NAME=%~n0"
set "_DBG_PREFIX=[%~dp0%_SCRIPT_NAME%] -"
shift
rem 
:begin
setlocal ENABLEEXTENSIONS
rem 
if defined _CLI_NOIG goto init
rem 
set "_SCRIPT_NAME=%~n0"
set "_DBG_PREFIX=[%~dp0%_SCRIPT_NAME%] -"
rem 
:init
set _CLI_PATH=
rem 
set _CLI_WIDTH=
set _CLI_HEIGHT=
rem 
set /A DEFAULT_SIZE=64
rem
if "%~1"=="" (
    if not defined _CLI_QUIET (
        echo %_DBG_PREFIX% Invalid argument count.
        echo Filter "%~0" expects exactly 1 argument.
    )
    rem goto abortInvalidOp
    exit /B 1
)
rem 
:loop
if "%~1"=="" (
    goto dealloc
)
rem 
rem else if "%~1"=="--outfile" (
rem     goto parseOutfile
rem ) else if /I "%~1"=="--out" (
rem     goto parseOutfile
rem ) else if /I "%~1"=="--of" (
rem     goto parseOutfile
rem ) else if /I "%~1"=="--o" (
rem     goto parseOutfile

if /I "%~1"=="--width" (
    goto parseWidth
) else if /I "%~1"=="--w" (
    goto parseWidth
) else if /I "%~1"=="--height" (
    goto parseHeight
) else if /I "%~1"=="--h" (
    goto parseHeight
) else (
    goto parseOutfileNoPreShift
    rem if not defined _CLI_QUIET (
    rem     echo %_DBG_PREFIX% invalid CLI option: "%~1"
    rem )
    rem goto dealloc
)
rem 
:shiftLoop
shift
goto loop
rem 
:parseWidth
rem 
shift
rem 
rem if not defined _CLI_WIDTH
set /A _CLI_WIDTH=%~1
rem 
if %_CLI_WIDTH% lss 1 (
    echo invalid image width, too small
    goto dealloc
) else if %_CLI_WIDTH% geq 2048 (
    echo invalid image width, too large
    goto dealloc
)
goto shiftLoop
rem 
:parseHeight
rem 
shift
rem 
rem if not defined _CLI_HEIGHT
set /A _CLI_HEIGHT=%~1
rem 
if %_CLI_HEIGHT% lss 1 (
    echo invalid image height, too small
    goto dealloc
) else if %_CLI_HEIGHT% geq 2048 (
    echo invalid image height, too large
    goto dealloc
)
goto shiftLoop
rem 
:parseOutfileNoPreShift
rem 
if "%~1"=="" (
    if not defined _CLI_QUIET (
        echo %_DBG_PREFIX% Invalid Source file @ "%~1".
    )
    rem goto abortInvalidFile
    exit /B 2
)

if exist "%~1" (
    if not defined _CLI_QUIET (
        echo %_DBG_PREFIX% overwriting Local source @ "%~1".
    )
    rem goto abortInvalidFile
    rem exit /B 2
)
set "_CLI_PATH=%~1.png"
rem 
if not defined _CLI_PATH (
    if not defined _CLI_QUIET (
        echo %_DBG_PREFIX% Source file not defined.
    )
    rem goto abortInvalidFile
    exit /B 2
)
rem 
:main
if not defined _CLI_WIDTH set /A _CLI_WIDTH=%DEFAULT_SIZE%
if not defined _CLI_HEIGHT set /A _CLI_HEIGHT=%DEFAULT_SIZE%
rem 
rem set "_URL_ARGS="
rem echo "%_URL_ARGS%"
rem 
if defined _CLI_PATH (
    curl -F w=%_CLI_WIDTH% -F h=%_CLI_HEIGHT% "https://vigilstudios.ca/pxgl-php56/greyscale/prbFill.php" --output "%_CLI_PATH%" || (
        if not defined _CLI_QUIET (
            echo %_DBG_PREFIX% calling curl --get https://vigilstudios.ca/ failed with source @ "%_CLI_PATH%"
        )
        goto dealloc
    )
    rem 
    rem for %%A in ( %_CLI_OUT_FILE% ) do set /A byteSize=%%~zA
    rem echo %byteSize% %SHA256_BYTE_SIZE%
    rem exit /b 0
    rem call :setErrorLevelIfInvalidSHA256ByteSize "%_CLI_OUT_FILE%" || (
    rem     echo %_DBG_PREFIX% aborting
    rem     goto dealloc
    rem )
    rem 
    rem ONLY output the first file if --out is specified otherwise,
    rem overwriting the same file multiple times with different values messes with the logic
    rem 
    rem goto dealloc
)
rem 
goto shiftLoop
rem 
rem @note files are always minified after being processed by the bundler!
rem 
rem unset variables at script shutdown
:dealloc
rem 
set DEFAULT_SIZE=
rem 
set _CLI_PATH=
rem 
set _CLI_WIDTH=
set _CLI_HEIGHT=
rem 
set _URL_ARGS=
rem set _CLI_OUT_FILE=
rem 
set _CLI_QUIET=
set _CLI_DBG=
rem 
rem set byteSize=
rem 
endlocal
rem 
rem 
exit /B %ERRORLEVEL%
rem 
rem @todo add Functions/subroutines here
rem 