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


rem /**
rem  * Output of help information about this file
rem  */
:help
ECHO -------------------------- AlternatePHP --------------------------
ECHO   AlternatePHP is a batch file for Windows environments that can
ECHO   make different versions of php available. It is inspired by
ECHO   phpenv / rbenv which is available on other operating systems.
ECHO.
ECHO   Visit on GitHub: https://github.com/glady/AlternatePHP
ECHO ------------------------------------------------------------------
ECHO.
ECHO current settings:
ECHO    global: !phpversion! [defined in !globalVersionFile!]
ECHO    local : -not supported yet-
ECHO.
ECHO supported actions:
ECHO  - php script.php ...       = call script with default php version
ECHO  - php x.y.z script.php ... = call script with php version x.y.z
ECHO  - php versions             = List all installed php versions
ECHO  - php install x.y.z        = Download and unzip php version x.y.z
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
    ECHO PHP !phpversion! is currently not installed.
    ECHO.
    GOTO help
)

"!versionsPath!\!phpversion!\php.exe" !params!
GOTO shutdown


rem /**
rem  * Retrieve a new php version
rem  */
:install
SET vc=VC9
SET architecture=x86
SET installVersion=%2
IF "!installVersion!" == ""  SET installVersion=!phpversion!
IF exist "!versionsPath!\!installVersion!\php.exe" (
    ECHO !installVersion! already exists!
    GOTO shutdown
)
IF "!installVersion!" gtr "5.5" (
    SET vc=VC11
)
IF "!installVersion!" gtr "7" (
    SET vc=VC14
    SET architecture=x64
)

IF not exist "!versionsPath!\!installVersion!.zip" CALL :downloadRelease
IF not exist "!versionsPath!\!installVersion!.zip" CALL :downloadArchive
IF not exist "!versionsPath!\!installVersion!.zip" (
    ECHO Download failed!
    GOTO shutdown
)
CALL :unzipAndConfigure
ECHO Added php version !installVersion! = thread safe, !vc!, !architecture!
ECHO  - copied php.ini-production as new php.ini
GOTO shutdown

rem /**
rem  * download php version from current releases
rem  */
:downloadRelease
SET url="http://windows.php.net/downloads/releases/php-!installVersion!-Win32-!vc!-!architecture!.zip"
ECHO  - Download: !url!
bitsadmin /rawreturn /transfer "PHP-Download !installVersion!" !url! !versionsPath!\!installVersion!.zip  > nul  2>&1
IF not exist "!versionsPath!\!installVersion!.zip" ECHO     - not successful!
EXIT /B 0

rem /**
rem  * download php version from archive
rem  */
:downloadArchive
SET url="http://windows.php.net/downloads/releases/archives/php-!installVersion!-Win32-!vc!-!architecture!.zip"
ECHO  - Download: !url!
bitsadmin /rawreturn /transfer "PP-Download !installVersion!" !url! !versionsPath!\!installVersion!.zip  > nul  2>&1
IF not exist "!versionsPath!\!installVersion!.zip" ECHO     - not successful!
EXIT /B 0

rem /**
rem  * unzip package and copy php.ini
rem  */
:unzipAndConfigure
unzip -qq !versionsPath!\!installVersion!.zip -d !versionsPath!\!installVersion!
del   !versionsPath!\!installVersion!.zip
copy  !versionsPath!\!installVersion!\php.ini-production !versionsPath!\!installVersion!\php.ini   > nul  2>&1
EXIT /B 0

rem /**
rem  * list installed versions
rem  */
:versions
ls "!versionsPath!"
GOTO shutdown

rem /**
rem  * switch global php version
rem  */
:global
IF not exist "!versionsPath!\%2\php.exe"     ECHO PHP %2 is currently not installed.
IF exist "!versionsPath!\%2\php.exe"         ECHO %2>!globalVersionFile!
GOTO shutdown

rem /**
rem  * end of script
rem  */
:shutdown
ENDLOCAL
EXIT /B %ERRORLEVEL%
