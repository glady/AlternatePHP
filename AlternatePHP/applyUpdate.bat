@ECHO off

SETLOCAL EnableDelayedExpansion

SET targetPath=%~dp1

echo xcopy /S /E "%~dp0.." "%~dp1"
xcopy "%~dp0.." "%~dp1" /S /E /Y