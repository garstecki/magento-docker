.PHONY: help start silent stop restart purge logs enter cache hints reindex dump mrun
.SILENT:

## This help screen
help:
	printf "Commands:\n"
	awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  %-15s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Start containers
start:
	touch local.env || exit
	@make silent
	@make logs

## Start containers, without printing logs
silent:
	docker-compose up -d

## Stop containers
stop:
	docker-compose stop

## Restart containers
restart:
	docker-compose restart

## Remove containers, database, logs and Magento's local.xml
purge:
	sudo rm -rf ./data/ ./logs/ ./web/app/etc/local.xml
	docker-compose stop
	docker-compose rm --force

## View logs
logs:
	docker-compose logs -f

## Enter container by giving it's name, e.g: make enter env=php
enter:
ifdef env
	printf "To exit container press: Ctrl + P then Ctrl + Q\n"
	@-docker exec -ti $(shell docker ps -q | xargs docker inspect --format "{{.Name}}" | grep "$(env)" | sed "s:/::" | grep "$(env)") bash
else
	printf "Please specify environment, e.g: make enter env=php\n"
endif

## Flush Magento cache, via magerun
cache:
	make mrun cmd=cache:flush

## Toggle template hints, via magerun
hints:
	make mrun cmd=dev:template-hints

## Reindex all, via magerun
reindex:
	make mrun cmd=index:reindex:all

## Dump database, via magerun
dump:
	make mrun cmd="db:dump --compression="gzip" ../database/db.sql.gz"

## Run magerun command, pass the command as cmd, e.g: make mrun cmd=sys:store:list
mrun:
ifdef cmd
	@-docker exec -ti $(shell docker ps -q | xargs docker inspect --format "{{.Name}}" | grep "php" | sed "s:/::" | grep "php") magerun --skip-root-check --root-dir="/var/www/html/web" $(cmd)
else
	printf "Please specify command, e.g: make mrun cmd=sys:store:list\n"
endif
