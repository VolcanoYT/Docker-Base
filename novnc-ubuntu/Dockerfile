FROM ubuntu:latest

ENV USER=sistem \
    WORK=/home/sistem \
    NO_VNC_PORT=6080 \
    VNC_PORT=5901 \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1920x1080 \
    VNC_PW=demo \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \ 
    LC_ALL=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive

EXPOSE $VNC_PORT $NO_VNC_PORT

RUN addgroup $USER && adduser $USER --ingroup $USER --shell /bin/sh --disabled-password &&\
    apt-get update && apt-get upgrade -y &&\    
    apt-get install -y --no-install-recommends \
    bash sudo wget ca-certificates supervisor unzip locales net-tools \
    xvfb x11vnc novnc xdg-utils \
    openbox tint2 ttf-dejavu \
    xfce4-terminal thunar nano &&\
    ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html &&\
    rm -rf /var/lib/apt/lists/* &&\
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

COPY config $WORK/.config/
COPY etc /etc/

RUN chown -R $USER $WORK/ &&\
    chmod -R 775 $WORK/

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]