@ECHO OFF

SET url=http://windows.php.net/downloads/releases/%1
ECHO    Download: !url!
bitsadmin /rawreturn /transfer "PHP-Download" !url! %2  > nul  2>&1
IF exist %2      ECHO       Successful!
IF not exist %2  ECHO       Not successful!
EXIT /B %ERRORLEVEL%
