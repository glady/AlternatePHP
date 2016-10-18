@ECHO off

rem /**
rem  * main script
rem  */
:main

SETLOCAL EnableDelayedExpansion

SET basepath=%~dp0
SET versionsPath=!basepath!php\versions
SET globalVersionFile=!basepath!php\php.version

SET /P phpversion=<!globalVersionFile!

IF "%1" == "help"      GOTO help
IF "%1" == "/?"        GOTO help
IF "%1" == "versions"  GOTO versions
IF "%1" == "install"   GOTO install
IF "%1" == "global"    GOTO global
GOTO php


:header
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
ECHO       global: !phpversion! [defined in !globalVersionFile!]
ECHO       local : -not supported yet-
ECHO.
ECHO    supported actions:
ECHO       php script.php ...       = call script with default php version
ECHO       php x.y.z script.php ... = call script with php version x.y.z
ECHO       php versions             = List all installed php versions
ECHO       php install x.y.z        = Download and unzip php version x.y.z
ECHO       php global x.y.z         = Change global php version
GOTO shutdown


rem /**
rem  * Find and call php version by first argument or by configured default version
rem  */
:php
rem shift first argument as version
IF exist "!versionsPath!\%1\php.exe" (
    SET phpversion=%1
    SHIFT
)

rem collect remaining arguments
SET params=
:loop
    IF [%1] == [] goto endloop
    SET params=!params! %1
    SHIFT
    goto loop
:endloop

rem call specific php
IF not exist "!versionsPath!\!phpversion!\php.exe" (
    ECHO    PHP !phpversion! is currently not installed
    ECHO.
    GOTO help
)

"!versionsPath!\!phpversion!\php.exe" !params!
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
!basepath!php\downloadPhp.bat php-!installVersion!-Win32-!vc!-!architecture!.zip !versionsPath!\!installVersion!.zip
EXIT /B %ERRORLEVEL%

:downloadArchive
!basepath!php\downloadPhp.bat archives/php-!installVersion!-Win32-!vc!-!architecture!.zip !versionsPath!\!installVersion!.zip
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

rem /**
rem  * end of script
rem  */
:shutdown
ENDLOCAL
EXIT /B %ERRORLEVEL%
