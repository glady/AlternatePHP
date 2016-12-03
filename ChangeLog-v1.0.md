# AlternatePHP v1.0.0

This was the initial release of the batch file on 2016-12-03. The php.bat wraps php calls and add possibility to change php version on the fly.

## New commands with v1.0.0

- `php help` and `php /?` outputs help information for AlternatePHP
- `php install` installs current default php version
- `php install <version>` installs given php version (format: e.g. `5.6.27`)
- `php versions` lists all currently installed versions
- `php global <version>` configure default version (like phpenv)
- `php -v` or `php <script.php> <arguments>` calls current default php version
- `php <version> -v` or `php <version> <script.php> <arguments>` calls the same on given php version (format: e.g. `5.6.27`)
- `php xdebug -v` or `php xdebug <script.php> <arguments>` calls current default php version with xdebug
- `php <version> xdebug -v` or `php <version> xdebug <script.php> <arguments>` calls the same on given php version with xdebug

## System requirements

- bitsadmin (for downloading binaries from http://windows.php.net/download)
- unzip (if not available yet, please download from http://gnuwin32.sourceforge.net/packages/unzip.htm and put unzip.exe to your PATH)

There should be no global installed PHP-Environment-Variables (like PHPRC) or other php.exe within PATH

## Optional system configurations

It is recommended to add AlternatePHP (directory where php.bat is located) to your PATH

## Internal default settings

- php default version is set to 7.0.12 and stored as global active version within `php/php.version`

## Issues and Pull Requests

- Issue #1 - `php <script.php> <arguments>` with arguments containing entry `<option>=<value>` are now supported
- Pull Request #2 - Added possibility to install Release-Candidates (e.g. 7.1.0-RC6)
