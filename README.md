# Docker compose for Magento

Based on: andreaskoch/dockerized-magento repo.
Prepared to use on existing projects. Build only for local development, certainly not for production usage.

## Bundle contains
* php 5.6
* nginx
* mysql
* gulp (node + npm)
* [magerun][magerun]
* [mailcatcher][mailcatcher] - [http://localhost:1080][mailcatcher-address]
* phpMyAdmin - [http://localhost:8080][phpmyadmin-address]

## Quick start
1. Clone or move your existing Magento project inside `/web` directory
2. Compress your database into `.gz` and place it inside `/database` directory
3. Run `make start` command, page is going to be accessible at `http://magento.dev`

## Features
Makefile provide shortcuts for most recently use commands.

* `make start` - starts project
* `make silent` - starts project without logs
* `make stop` - stops project
* `make restart` - restarts project
* `make purge` - drops database, and stops the project
* `make logs` - prints logs
* `make enter env=foo` - ssh into the running foo container
* `make cache` - flushes Magento cache
* `make hints` - toggles Magento template hints 
* `make reindex` - runs Magento reindex all
* `make dump` - Dumps current database state into `/database/db.sql.gz`
* `make mrun cmd=foo` - runs magerun foo command

## Things done under the hood
* xdebug is enabled and should run out of the box
* nginx sets `MAGE_IS_DEVELOPER_MODE` to `true`
* Magento admin panel forces https connection by default
* Magento installer while importing new database:
 * remove all base_urls
 * add store codes to urls
 * switch language to `en_GB`
 * disable all caches

## Usage examples

### Import new database
Place new database file compressed to `.gz` inside `/database` dir, and remove all other database files from that directory. Run `make purge` and then `make start`.

### SSH into certain container
* `make enter env=php` - php container
* `make enter env=nginx` - nginx container
* `make enter env=mysql` - mysql container
* `make enter env=node` - gulp (node + npm) container
* `make enter env=mailcatcher` - mailcatcher container
* `make enter env=dbinterface` - phpMyAdmin container

### Run certain magerun command
For instance to view all store views, run `make mrun cmd=sys:store:list`. List of all magerun commands is available on theirs [github page][magerun].

For the commands which includes spaces, wrap them inside quotes. For instance: `make mrun cmd="sys:info version"`.

[mailcatcher]:https://mailcatcher.me/
[mailcatcher-address]:http://localhost:1080
[phpmyadmin-address]:http://localhost:1080
[magerun]:https://github.com/netz98/n98-magerun
