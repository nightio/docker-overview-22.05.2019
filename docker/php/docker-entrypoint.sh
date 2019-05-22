#!/bin/sh

mkdir -p var/cache var/log
set +e
setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX var
setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX var
set -e

if [ "$APP_ENV" != 'prod' ]; then
	    touch .env
		composer install --prefer-dist --no-progress --no-suggest --no-interaction
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- apache2-foreground "$@"
fi

exec "$@"