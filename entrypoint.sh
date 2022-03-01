#!/usr/bin/env bash

# Wait for postgress to start
until /usr/bin/pg_isready -d ${POSTGRES_DB} -h ${COMPOSE_PROJECT_NAME}_database_1 -p ${POSTGRES_PORT}  -U ${POSTGRES_USER}; do
	echo 'wait for postgres to start...'
	sleep 5
done

# Setup postgres database link. Environment vars 
# for database link are set in 'config.env'.
export DATABASE_URL=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${COMPOSE_PROJECT_NAME}_database_1/${POSTGRES_DB}

# If run for the first time, set up databases
if [ ! -f "/opt/init/.done" ]; then
    /usr/bin/env python -u /usr/local/bin/otree resetdb --noinput \
    && touch /opt/init/.done
fi

# Start oTree server
cd /opt/otree && otree runprodserver 80
 