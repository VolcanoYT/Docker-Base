FROM ubuntu:focal

RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;

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

RUN addgroup $USER && adduser $USER --ingroup $USER --shell /bin/sh --disabled-password --force &&\
    apt-get update && apt-get upgrade -y &&\
    apt-get install -y --no-install-recommends \
    bash sudo wget ca-certificates supervisor unzip locales net-tools procps binutils \
    xvfb dbus-x11 x11vnc novnc xdg-utils alsa-utils \
    mesa-utils libgl1-mesa-dri \
    ttf-ubuntu-font-family ttf-wqy-zenhei fonts-liberation \
    openbox tint2 qt5-default \
    xfce4-terminal thunar nano &&\
    ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html &&\
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# tini to fix subreap
ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

COPY config $WORK/.config/
COPY etc /etc/

RUN chown -R $USER $WORK/ &&\
    chmod -R 775 $WORK/

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]