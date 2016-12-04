@ECHO off

rem /**
rem  * main script
rem  */
:main

SETLOCAL EnableDelayedExpansion

rem load all params as string
rem (this contains also parts like a=b, while access single params would deliver %1=a and %2=b without information which character is between that)
SET params=%*

SET basepath=%~dp0
SET versionsPath=!basepath!php\versions
SET globalVersionFile=!basepath!php\php.version

if exist "!globalVersionFile!" (
    SET loadedGlobalVersionFile=!globalVersionFile!
)
if not exist "!globalVersionFile!" (
    SET loadedGlobalVersionFile=!basepath!php\default.php.version
)
SET /P phpversion=<!loadedGlobalVersionFile!

IF "%1" == "help"      GOTO help
IF "%1" == "/?"        GOTO help
IF "%1" == "versions"  GOTO versions
IF "%1" == "install"   GOTO install
IF "%1" == "global"    GOTO global
GOTO php

:outputVersionInformation
ECHO glady/AlternatePhp v1.0.0
EXIT /B 0

:header
ECHO.
CALL :outputVersionInformation
ECHO.
ECHO  -------------------------- AlternatePHP --------------------------
ECHO    AlternatePHP is a batch file for Windows environments that can
ECHO    make different versions of php available. It is inspired by
ECHO    phpenv / rbenv which is available on other operating systems.
ECHO.
ECHO    Visit on GitHub: https://github.com/glady/AlternatePHP
ECHO  ------------------------------------------------------------------
ECHO.
EXIT /B 0

rem /**
rem  * Output of help information about this file
rem  */
:help
CALL :header
ECHO    current settings:
ECHO       global: !phpversion! [defined in !loadedGlobalVersionFile!]
ECHO       local : -not supported yet-
ECHO.
ECHO    call scripts in a specific PHP version
ECHO       php [version] [xdebug] script.php
ECHO         version = optional, default version is used, when not given
ECHO         xdebug  = enables xdebug, if php_xdebug.dll is available within ext-folder of version, default disabled
ECHO.
ECHO    supported wrapper actions:
ECHO       php versions                    = List all installed php versions
ECHO       php install x.y.z               = Download and unzip php version x.y.z
ECHO       php global x.y.z                = Change global php version
GOTO shutdown


rem /**
rem  * Find and call php version by first argument or by configured default version
rem  */
:php

SET prepend=

CALL :trimStringLeft params "!params!"
rem shift first argument as version
IF exist "!versionsPath!\%1\php.exe" (
    SET phpversion=%1
    SHIFT
    rem remove version from params
    CALL :strlen !phpversion! length
    CALL :removeFromStringLeft params "!params!" !length!
    CALL :trimStringLeft params "!params!"
)

rem shift next (or first) argument named xdebug
IF [%1] == [xdebug] (
    CALL :removeFromStringLeft params "!params!" 7
    CALL :trimStringLeft params "!params!"
    IF exist "!versionsPath!\!phpversion!\ext\php_xdebug.dll" (
        rem prepend "-d" before remaining arguments
        SET prepend=-d "zend_extension=!versionsPath!\!phpversion!\ext\php_xdebug.dll"
    )
    SHIFT
)

rem call specific php
IF not exist "!versionsPath!\!phpversion!\php.exe" (
    ECHO    PHP !phpversion! is currently not installed
    ECHO.
    GOTO help
)

if "!params:~0,2!" == "-v" (
    CALL :outputVersionInformation
)
if "!params:~0,9!" == "--version" (
    CALL :outputVersionInformation
)

"!versionsPath!\!phpversion!\php.exe" !prepend! !params!
GOTO shutdown


rem /**
rem  * Retrieve a new php version
rem  */
:install

CALL :header

SET vc=VC9
SET architecture=x86
SET installVersion=%2
IF "!installVersion!" == ""  SET installVersion=!phpversion!
IF exist "!versionsPath!\!installVersion!\php.exe" (
    ECHO    PHP !installVersion! is already installed
    GOTO shutdown
)
IF "!installVersion!" gtr "5.5" (
    SET vc=VC11
)
IF "!installVersion!" gtr "7" (
    SET vc=VC14
    SET architecture=x64
)
IF exist "!versionsPath!\!installVersion!.zip"     ECHO    !versionsPath!\!installVersion!.zip already downloaded
IF not exist "!versionsPath!\!installVersion!.zip" CALL :downloadRelease
IF not exist "!versionsPath!\!installVersion!.zip" CALL :downloadArchive
IF not exist "!versionsPath!\!installVersion!.zip" CALL :downloadCandidate
IF not exist "!versionsPath!\!installVersion!.zip" (
    ECHO    Download failed
    GOTO shutdown
)
CALL :unzipAndConfigure
IF "%ERRORLEVEL%" NEQ "0"  GOTO shutdown

ECHO.
ECHO    Successfully added php version !installVersion! [thread safe, !vc!, !architecture!]
GOTO shutdown


:downloadRelease
CALL :downloadPhp releases/php-!installVersion!-Win32-!vc!-!architecture!.zip !versionsPath!\!installVersion!.zip
EXIT /B %ERRORLEVEL%

:downloadArchive
CALL :downloadPhp releases/archives/php-!installVersion!-Win32-!vc!-!architecture!.zip !versionsPath!\!installVersion!.zip
EXIT /B %ERRORLEVEL%

:downloadCandidate
CALL :downloadPhp qa/php-!installVersion!-Win32-!vc!-!architecture!.zip !versionsPath!\!installVersion!.zip
EXIT /B %ERRORLEVEL%

:downloadPhp
SET url=http://windows.php.net/downloads/%1
ECHO    Download: !url!
bitsadmin /rawreturn /transfer "PHP-Download" !url! %2  > nul  2>&1
IF exist %2      ECHO       Successful!
IF not exist %2  ECHO       Not successful!
EXIT /B %ERRORLEVEL%


rem /**
rem  * unzip package and copy php.ini
rem  */
:unzipAndConfigure
ECHO    unzip downloaded binaries to !versionsPath!\!installVersion!

CALL :checkUnzip
IF "%ERRORLEVEL%" NEQ "0" (
    ECHO       no unzip found!
    EXIT /B %ERRORLEVEL%
)

unzip -qq !versionsPath!\!installVersion!.zip -d !versionsPath!\!installVersion!
rem del   !versionsPath!\!installVersion!.zip

ECHO    copy php.ini-production to php.ini
copy  !versionsPath!\!installVersion!\php.ini-production !versionsPath!\!installVersion!\php.ini   > nul  2>&1
EXIT /B 0

rem /**
rem  * list installed versions
rem  */
:versions
dir "!versionsPath!" /B /A:D
GOTO shutdown

rem /**
rem  * switch global php version
rem  */
:global
IF not exist "!versionsPath!\%2\php.exe"     ECHO    PHP %2 is currently not installed
IF exist "!versionsPath!\%2\php.exe"         ECHO %2>!globalVersionFile!
GOTO shutdown

:checkUnzip
where unzip  > nul  2>&1
EXIT /B %ERRORLEVEL%

rem implementation of string length (string, &length)
:strlen
set stringY=%~1%
set /A lengthY=0
:stringLengthLoop
if defined stringY (set stringY=%stringY:~1%&set /A lengthY += 1&goto stringLengthLoop)
set "%~2=%lengthY%"
GOTO :EOF

rem implementation of cutting off first x characters (&out, in length)
:removeFromStringLeft
set stringX=%~2%
set /A lengthX=%3%
:removeFromStringLeftLoop
if %lengthX% gtr 0 (set stringX=%stringX:~1%&SET /A lengthX -= 1&goto removeFromStringLeftLoop)
set "%1=%stringX%"
GOTO :EOF

rem implementation of cutting off first characters that are spaces (left trim) (&out, in)
:trimStringLeft
set stringZ=%~2%
:trimStringLeftLoop
if "%stringZ:~0,1%" == " " (set stringZ=%stringZ:~1%&goto trimStringLeftLoop)
set "%1=%stringZ%"
GOTO :EOF

rem /**
rem  * end of script
rem  */
:shutdown
ENDLOCAL
EXIT /B %ERRORLEVEL%
