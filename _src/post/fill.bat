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
rem set _CLI_OUT_FILE=
rem 
set _CLI_WIDTH=
set _CLI_HEIGHT=
rem 
set _CLI_RED=
set _CLI_GREEN=
set _CLI_BLUE=
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
) else if /I "%~1"=="--red" (
    goto parseRed
) else if /I "%~1"=="--r" (
    goto parseRed
) else if /I "%~1"=="--green" (
    goto parseGreen
) else if /I "%~1"=="--g" (
    goto parseGreen
) else if /I "%~1"=="--blue" (
    goto parseBlue
) else if /I "%~1"=="--b" (
    goto parseBlue
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
:parseRed
rem 
shift
rem 
rem if not defined _CLI_RED
set /A _CLI_RED=%~1
rem 
if %_CLI_RED% lss 0 (
    echo invalid red channel, too small
    goto dealloc
) else if %_CLI_RED% gtr 255 (
    echo invalid red channel, too large
    goto dealloc
)
goto shiftLoop
rem 
:parseGreen
rem 
shift
rem 
rem if not defined _CLI_GREEN
set /A _CLI_GREEN=%~1
rem 
if %_CLI_GREEN%% lss 0 (
    echo invalid green channel, too small
    goto dealloc
) else if %_CLI_GREEN% gtr 255 (
    echo invalid  green channel, too large
    goto dealloc
)
goto shiftLoop
rem 
:parseBlue
rem 
shift
rem 
rem if not defined _CLI_BLUE
set /A _CLI_BLUE=%~1
rem 
if %_CLI_BLUE% lss 0 (
    echo invalid blue channel, too small
    goto dealloc
) else if %_CLI_BLUE% gtr 255 (
    echo invalid blue channel, too large
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
if not defined _CLI_RED set /A _CLI_RED=0
if not defined _CLI_GREEN set /A _CLI_GREEN=0
if not defined _CLI_BLUE set /A _CLI_BLUE=0
rem 
if defined _CLI_PATH (
    curl -F w=%_CLI_WIDTH% -F h=%_CLI_HEIGHT% -F r=%_CLI_RED% -F g=%_CLI_GREEN% -F b=%_CLI_BLUE% "https://vigilstudios.ca/pxgl-php56/fill.php" --output "%_CLI_PATH%" || (
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
rem else (
    rem 
    rem output results directly to console
    rem 
    rem @note this may cause issues with output if whitespace or other
    rem non-human readable chars are output to cout
    rem (since it is not intended to display binary) but will still write the
    rem correct result if option --outfile is provided
    rem 
rem     curl --get "https://vigilstudios.ca/pxgl-php56/random/square.php?s=%_CLI_SIZE%" > nul || (
rem         if not defined _CLI_QUIET (
rem             echo %_DBG_PREFIX% calling curl --get https://vigilstudios.ca/pxgl-php56/
rem         )
rem         goto dealloc
rem     )
rem     rem goto shiftLoop
rem )
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
set _CLI_WIDTH=
set _CLI_HEIGHT=
rem 
set _CLI_RED=
set _CLI_GREEN=
set _CLI_BLUE=
rem 
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
rem
:setErrorLevelIfInvalidSHA256ByteSize
rem 
if not exist "%~1" (
    echo file does not exist @ "%~1"
    rem 
    exit /b 2
)
rem 
set /A "_BYTE_SIZE=32"
rem for %%A in ( %~1 ) do set /A byteSize=%%~zA
set /A "byteSize=%~z1"

rem if not %SHA256_BYTE_SIZE% equ %byteSize% (
if not "%_BYTE_SIZE%"=="%byteSize%" (
    echo invalid byte size for %byteSize% for SHA256 digest @ "%~1"
    rem 
    set _BYTE_SIZE=
    set byteSize=
    rem 
    exit /b 2
)
set _BYTE_SIZE=
set byteSize=
rem 
exit /b 0
rem 