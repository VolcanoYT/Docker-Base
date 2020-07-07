FROM alpine:edge

ENV USER=sistem \
    WORK=/home/sistem \
    NO_VNC_PORT=6080 \
    VNC_PORT=5901 \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1920x1080 \
    VNC_PW=demo \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

EXPOSE $VNC_PORT $NO_VNC_PORT

RUN addgroup $USER && adduser -G $USER -s /bin/sh -D $USER &&\
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories &&\
    apk --update --no-cache add \
    bash sudo wget ca-certificates supervisor unzip \
    mesa-dri-swrast xvfb x11vnc novnc xdg-utils xset \
    ttf-dejavu openbox tint2 \
    xfce4-terminal thunar nano &&\
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub &&\
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-2.31-r0.apk &&\
    apk add glibc-2.31-r0.apk &&\
    cd $WORK &&\
    ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

COPY config $WORK/.config/
COPY etc /etc/

RUN mkdir -p /run/dbus &&\
    chown -R $USER $WORK/ &&\
    chmod -R 775 $WORK/

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]