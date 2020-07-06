FROM node:current-alpine

ENV USER=sistem \
    GRUP=nobody \
    WORKD=/usr/src/app \
    UID=1001 \
    GID=1001

# Instal PM2 as root
RUN npm i pm2 -g

# Add sistem pada grup nobody
RUN adduser --disabled-password --gecos "" --home "$WORKD" --ingroup "$GRUP" --no-create-home --uid "$UID" "$USER"

# Copy Base Data (copy data if your job is done, for now just use ftp for dev mode)
RUN mkdir -p $WORKD
WORKDIR $WORKD