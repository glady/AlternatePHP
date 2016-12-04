# AlternatePHP v1.1.0

This release has some internal changes for preparing self-update of AlternatePhp 

## New commands with v1.1.0

- `php license` shows content of license file
- `php rename <version> <version>` for support custom version alias

## System requirements

- bitsadmin (for downloading binaries from http://windows.php.net/download)
- unzip (if not available yet, please download from http://gnuwin32.sourceforge.net/packages/unzip.htm and put unzip.exe to your PATH)

There should be no global installed PHP-Environment-Variables (like PHPRC) or other php.exe within PATH

## Optional system configurations

It is recommended to add AlternatePHP (directory where php.bat is located) to your PATH

## Internal default settings

- php default version is increased to 7.0.13 (latest release of 7.0)

## Issues and Pull Requests

- enhancement #3 - prepend AlternatePhp version-information to `php -v` call
- enhancement #4 - exclude default `php/php.version` file and set default within `php.bat` (it would be overwritten on self-update)
- enhancement #6 - `php rename <version> <version>` for support custom version alias
