# AlternatePHP v1.2.0

This release has some short-cut functionallity for Composer and XDebug. 

## New commands with v1.2.0

- `php [<version>] [xdebug] composer <command>` run latest composer.phar

## System requirements

- bitsadmin (for downloading binaries from http://windows.php.net/download)
- unzip (if not available yet, please download from http://gnuwin32.sourceforge.net/packages/unzip.htm and put unzip.exe to your PATH)

There should be no global installed PHP-Environment-Variables (like PHPRC) or other php.exe within PATH

## Optional system configurations

It is recommended to add AlternatePHP (directory where php.bat is located) to your PATH

## Internal default settings

- php default version is increased to 7.0.13 (latest release of 7.0)

## Issues and Pull Requests

- enhancement #7 - Add short-cut calls to latest composer package
