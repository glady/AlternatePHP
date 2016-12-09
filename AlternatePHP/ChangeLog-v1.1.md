# AlternatePHP v1.1.0

This release has some internal changes for preparing self-update of AlternatePHP 

## New commands with v1.1.0

- `php license` shows content of license file
- `php rename <version> <version>` for support custom version alias
- `php self-update` download latest release of AlternatePHP from GitHub

## System requirements

- bitsadmin (for downloading binaries from http://windows.php.net/download)
- unzip (if not available yet, please download from http://gnuwin32.sourceforge.net/packages/unzip.htm and put unzip.exe to your PATH)

There should be no global installed PHP-Environment-Variables (like PHPRC) or other php.exe within PATH

## Optional system configurations

It is recommended to add AlternatePHP (directory where php.bat is located) to your PATH

## Internal default settings

- php default version is increased to 7.0.13 (latest release of 7.0)

## Issues and Pull Requests

- enhancement #3 - prepend AlternatePHP version-information to `php -v` call
- enhancement #4 - exclude default `php/php.version` file and set default within `php.bat` (it would be overwritten on self-update)
- enhancement #5 - `php self-update` download latest release of AlternatePHP from GitHub
- enhancement #6 - `php rename <version> <version>` for support custom version alias

## Known problems

- Download release from GitHub needs an redirect with a specific HTTP-Protocol. On some tests of developer before releasing this
 version, the connection used a proxy that does not support this case of protocol. Please check which connection is used
 if there are problems and try a direct connection without any proxy.``