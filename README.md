# AlternatePHP

AlternatePHP is a batch file for Windows environments that can make different versions of php available. It is inspired by phpenv / rbenv which is available on other operating systems.

Goals:
- Simply execute your script with another version of php
- Quick "install" of a new version

Current default PHP version: 7.0.13

## Basic usage

- `php -v` or `php <script.php> <arguments>` calls current default php version
- `php <version> -v` or `php <version> <script.php> <arguments>` calls the same on given php version (format: e.g. `5.6.27`)
- `php xdebug -v` or `php xdebug <script.php> <arguments>` calls current default php version with xdebug
- `php <version> xdebug -v` or `php <version> xdebug <script.php> <arguments>` calls the same on given php version with xdebug

## Added/modified commands

- `php --version` and `php -v` outputs version AlternatePHP before original output
- `php help` and `php /?` outputs help information for AlternatePHP
- `php install` installs current default php version
- `php install <version>` installs given php version (format: e.g. `5.6.27`)
- `php versions` lists all currently installed versions
- `php global <version>` configure default version (like phpenv)
- `php rename <version> <version>` for support custom version alias
- `php license` for output of LICENSE

## Planned 

- [v1.1] #5 - `php self-update` download latest release of AlternatePhp from GitHub
- `php local <version>` configure version for current folder (like phpenv)
- `php configure <version> ...` is planned for some php.ini modifications (interface/arguments not planned yet)
- `php enable-xdebug <version>` directly add correct php_xdebug.dll to given version and add extension to php.ini 
- `php disable-xdebug <version>` remove extension from php.ini

## System requirements

- bitsadmin (for downloading binaries from http://windows.php.net/download)
- unzip (if not available yet, please download from http://gnuwin32.sourceforge.net/packages/unzip.htm and put unzip.exe to your PATH)

There should be no global installed PHP-Environment-Variables (like PHPRC) or other php.exe within PATH

## Optional system configurations

It is recommended to add AlternatePHP (directory where php.bat is located) to your PATH

## Installation

1. Download zip (latest release or from current master)
2. unzip to a folder
3. optional: put unzip.exe to the same folder, if not available on the system
4. add that folder to path
5. optional: use `php global <version>` to specify your version (if not set, the default is used)
6. call `php install` to download and unzip that php version

It is recommended to set a global version, because after next update another php version can be set as default.

## Update

You should use `php self-update` (available with v1.1) to update your installation. 
Without self-update: download zip and unzip over existing installation.

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
glady/AlternatePhp v1.0.0
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
glady/AlternatePhp v1.0.0
PHP 7.0.12 (cli) (built: Oct 13 2016 10:47:49) ( ZTS )
Copyright (c) 1997-2016 The PHP Group
Zend Engine v3.0.0, Copyright (c) 1998-2016 Zend Technologies

$ php 5.6.27 -v
glady/AlternatePhp v1.0.0
PHP 5.6.27 (cli) (built: Oct 14 2016 10:23:05)
Copyright (c) 1997-2016 The PHP Group
Zend Engine v2.6.0, Copyright (c) 1998-2016 Zend Technologies

$ php 7.0.12 -v
glady/AlternatePhp v1.0.0
PHP 7.0.12 (cli) (built: Oct 13 2016 10:47:49) ( ZTS )
Copyright (c) 1997-2016 The PHP Group
Zend Engine v3.0.0, Copyright (c) 1998-2016 Zend Technologies

```

When php_xdebug.dll (named like this) is available within `ext` folder of current php folder, then a script can be called
 by `php xdebug script.php` for loading xdebug within that process.
```
$ php xdebug -v
glady/AlternatePhp v1.0.0
PHP 7.0.12 (cli) (built: Oct 13 2016 10:47:49) ( ZTS )
Copyright (c) 1997-2016 The PHP Group
Zend Engine v3.0.0, Copyright (c) 1998-2016 Zend Technologies
    with Xdebug v2.4.1, Copyright (c) 2002-2016, by Derick Rethans

$ php 7.0.12 xdebug -v
glady/AlternatePhp v1.0.0
PHP 7.0.12 (cli) (built: Oct 13 2016 10:47:49) ( ZTS )
Copyright (c) 1997-2016 The PHP Group
Zend Engine v3.0.0, Copyright (c) 1998-2016 Zend Technologies
    with Xdebug v2.4.1, Copyright (c) 2002-2016, by Derick Rethans
```
