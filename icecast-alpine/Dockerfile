FROM alpine:edge

EXPOSE 8010

RUN addgroup -S icecast && adduser -S icecast

RUN apk add --no-cache --update icecast mailcap &&\
    mkdir -p /usr/local/icecast/logs/ &&\
    chown -R icecast /usr/local/icecast/logs/ &&\
    chmod -R 775 /usr/local/icecast/logs/

COPY config/icecast.xml /etc/icecast.xml

USER icecast
CMD icecast -c /etc/icecast.xml