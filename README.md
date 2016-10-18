# AlternatePHP

AlternatePHP is a batch file for Windows environments that can make different versions of php available. It is inspired by phpenv / rbenv which is available on other operating systems.

Goals:
- Simply execute your script with another version of php
- Quick "install" of a new version

## Basic usage

- `php -v` or `php <script.php> <arguments>` calls current default php version
- `php <version> -v` or `php <version> <script.php> <arguments>` calls the same on given php version (format: e.g. `5.6.27`)

## Added commands

- `php help` and `php /?` outputs help information for AlternatePHP
- `php install` installs current default php version
- `php install <version>` installs given php version (format: e.g. `5.6.27`)
- `php versions` lists all currently installed versions
- `php global <version>` configure default version (like phpenv)

## Planned commands

- `php local <version>` configure version for current folder (like phpenv)
- `php rename <version> <version>` for support custom version alias
- `php configure <version> ...` is planned for some php.ini modifications (interface/arguments not planned yet)
- `php enable-xdebug <version>` directly add correct php_xdebug.dll to given version and add extension to php.ini 
- `php disable-xdebug <version>` remove extension from php.ini

## System requirements

- bitsadmin (for downloading binaries from http://windows.php.net/download)
- unzip (if not available yet, please download from http://gnuwin32.sourceforge.net/packages/unzip.htm and put unzip.exe to your PATH)

There should be no global installed PHP-Environment-Variables (like PHPRC) or other php.exe within PATH

## Optional system configurations

It is recommended to add AlternatePHP (directory where php.bat is located) to your PATH

## Example

```bash
$ git clone https://github.com/glady/AlternatePHP.git
$ cd AlternatePHP
$ php versions

$ php help
[...]

$ php install
[... downloads default php version ...]
[... unzips downloaded version ...]
[... copy php.ini-production to php.ini ...]

$ php versions
7.0.12

$ php -v
PHP 7.0.12 (cli) (built: Oct 13 2016 10:47:49) ( ZTS )
Copyright (c) 1997-2016 The PHP Group
Zend Engine v3.0.0, Copyright (c) 1998-2016 Zend Technologies

$ php install 5.6.27
[... downloads php 5.6.27 ...]
[... unzips downloaded version ...]
[... copy php.ini-production to php.ini ...]

$ php versions
5.6.27  7.0.12

$ php -v
PHP 7.0.12 (cli) (built: Oct 13 2016 10:47:49) ( ZTS )
Copyright (c) 1997-2016 The PHP Group
Zend Engine v3.0.0, Copyright (c) 1998-2016 Zend Technologies

$ php 5.6.27 -v
PHP 5.6.27 (cli) (built: Oct 14 2016 10:23:05)
Copyright (c) 1997-2016 The PHP Group
Zend Engine v2.6.0, Copyright (c) 1998-2016 Zend Technologies

$ php 7.0.12 -v
PHP 7.0.12 (cli) (built: Oct 13 2016 10:47:49) ( ZTS )
Copyright (c) 1997-2016 The PHP Group
Zend Engine v3.0.0, Copyright (c) 1998-2016 Zend Technologies

```
