FROM python:3.8-alpine

# This is based in parts on
# https://github.com/dacrystal/otree-docker 

LABEL maintainer="Joachim Gassen <gassen@wiwi.hu-berlin.de>" 

ENV APP_DIR=/opt/otree
ENV DJANGO_SETTINGS_MODULE 'settings'
ARG OTREE_APP_FOLDER=app
 
# app dirs
RUN mkdir -p ${APP_DIR} \
    && mkdir -p /opt/init

# dev tools
RUN apk -U add --no-cache bash gcc musl-dev postgresql-client postgresql-dev

# app requirements - we no longer use requirements_base.txt
# add it if you need it
COPY ${OTREE_APP_FOLDER}/requirements.txt ${APP_DIR}

# Install requirements
RUN pip install --no-cache-dir -r ${APP_DIR}/requirements.txt

# copy app source
ADD ${OTREE_APP_FOLDER} ${APP_DIR}

# startup script
ADD entrypoint.sh ${APP_DIR}
RUN chmod +x ${APP_DIR}/entrypoint.sh

WORKDIR ${APP_DIR}
VOLUME /opt/init
ENTRYPOINT ${APP_DIR}/entrypoint.sh
EXPOSE 80
