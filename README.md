
## A Docker-based setup for oTree 


This repo contains a docker-compose setup that allows users to spin up an
[oTree](https://www.otree.org) instance relatively quickly. 
Is is based on a repo of Nasser Alansari 
(https://github.com/dacrystal/otree-docker) but has been adapted 
to reflect recent changes in oTree 5.x. Not surprisingly, it requires
a working installation of [docker](https://www.docker.com).


### Setup

First clone (download) this repo:

```
git clone https://github.com/trr266/otree_docker <unique-project-name>
```

Then clone (or copy) your oTree project in inside it. By default, docker
compose assumes the project to reside in an folder named `app` but this
can be changed by setting an argument  in the `docker-compose.yml` file.

```
git clone <your-otree-project-repo> app
```        

Next, take a look at `config.env`. It sets the docker compose project name 
and some defaults for the oTree and Postgres containers. If you build 
separate containers for separate  experiments, make sure to use different 
`COMPOSE_PROJECT_NAME`s  and also different forwarding ports to avoid conflicts.
 
Then, you need to set the passwords for the oTree instance and the 
Postgres database. For this, copy the `_secrets.env` file to `secrets.env`
and edit the passwords as well as the oTree API key. `secrets.env` is 
included in `.gitignore` to avoid accidental commits. 

Finally, you should adjust the port that the host forwards the traffic from
the oTree container to. It defaults to 9090. You can change this port in
`docker-compose.yml`. 


### Testing

To start oTree services for the first time run:

```
docker-compose -p otree5 up --build
```

Make sure that the project name given by the `-p` option matches the one 
specified in `config.env`. After building the `oTree` container, this should 
start two containers: The `oTree` container and a Postgres container that 
provides the database. 

The call above will start the containers logging to the console. If everything
works, you should see something like

```
... many other lines omitted ...
otree_1     | otree5_database_1:5432 - accepting connections
otree_1     | Running prodserver
```

If you do, perfect. Ctrl-C to wind down the containers and start them again
in the background:

```
docker-compose -p otree5 up -d
```

Test your container by accessing it via `http://localhost:9090` (adjust the
port if need be). See below for additional info.

If it does not work, consider changing the entrypoint in the Dockerfile to
bash

```
# ENTRYPOINT ${APP_DIR}/entrypoint.sh
CMD ["/bin/bash"]
```

and add 

```
stdin_open: true
tty: true
```

to the `otree` service  in `docker-compose.yaml` (watch out for the
indentation) to make sure that you can shell it into the oTree container 
for further testing via:

```
docker-compose -p otree5 up --build -d
docker attach otree5_otree_1
```

In addition, you can also take a look at the logs`of the running container

```
docker logs -f otree5_otree_1
```

Good luck!


### Further Info

As database data are defined as *volumes* in the `docker-compose.yml`,
you can easily update your otree container without resetting your data 
by running:

```
docker-compose -p otree5 up --build -d
```

If you need to reset your database (`resetdb`), then use the `-v` switch
when shutting down the containers. This will delete the associated data
volumes. 

```
docker-compose -p otree5 down -v && docker-compose -p otree5 up --build -d
```

### Warning
  
When rebuilding docker containers, make sure that you store all
experimental data before or use a different docker-compose project 
name (see remarks about `config.env` file and the `-p` option above).


### Example docker-compose commands

```shell
# Start all containers
docker-compose -p otree5 up -d

# Start all containers with rebuilding image
docker-compose -p otree5 up --build -d

# Stop containers
docker-compose -p otree5 down

# Stop containers and delete all data
docker-compose -p otree5 down -v
```


### Additional python modules

All additional python module should be add to requirements.txt in your 
otree project.


### Configuration 

### `config.env` file options

- `COMPOSE_PROJECT_NAME` project name for docker compose to name the containers (default: 'otree')
- `PG_DATABASE`: database name
- `PG_USER`: database user 
- `PG_PORT`: port for Postgres 
- `OTREE_PRODUCTION`: otree production mode
- `OTREE_AUTH_LEVEL`: `DEMO` (studies can be started by everybody) or
`STUDY` (only people with dedicated link can start)

You can add additional oTree environment variables to this file as you
please.


### `secret-env` file options
- `PG_PASSWORD`: database password
- `OTREE_ADMIN_PASSWORD`: otree admin password
- `OTREE_REST_KEY`: key for the OTree Rest API


### OTree documentation

- http://otree.readthedocs.io/en/latest/
