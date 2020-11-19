ARG VersionFFMPEG=0.0.1

FROM node:current-alpine AS base

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN  apk add --no-cache --update libgcc libstdc++ ca-certificates libcrypto1.1 libssl1.1 libgomp expat git linux-headers

FROM base AS build

WORKDIR     /tmp/workdir

RUN buildDeps=" \    
    autoconf \
    automake \
    bash \
    binutils \
    bzip2 \
    cmake \
    curl \
    coreutils \
    diffutils \
    file \
    g++ \
    gcc \
    gperf \
    libtool \
    make \
    python3 \
    openssl-dev \
    tar \
    yasm \
    nasm \
    zlib-dev \
    expat-dev \
    mercurial" && \
    apk add --no-cache --update ${buildDeps}

ARG  LD_LIBRARY_PATH=/opt/ffmpeg/lib
ARG  MAKEFLAGS="-j2"
ARG  PKG_CONFIG_PATH="/opt/ffmpeg/share/pkgconfig:/opt/ffmpeg/lib/pkgconfig:/opt/ffmpeg/lib64/pkgconfig"
ARG  PREFIX=/opt/ffmpeg
ARG  LD_LIBRARY_PATH="/opt/ffmpeg/lib:/opt/ffmpeg/lib64"

# OpenCORE Framework implementation of Adaptive Multi Rate Narrowband and Wideband (AMR-NB and AMR-WB) speech codec. (TODO: need update)
RUN \
    DIR=/tmp/opencore-amr && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://versaweb.dl.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.5.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-shared  && \
    make && \
    make install && \
    rm -rf ${DIR}

# x264 is a free software library and application for encoding video streams into the H.264/MPEG-4 AVC compression format
RUN \
    DIR=/tmp/x264 && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2 | \
    tar -jx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-shared --enable-pic --disable-cli && \
    make && \
    make install && \
    rm -rf ${DIR}

# x265 is a library for encoding video into the High Efficiency Video Coding (HEVC/H. 265) video compression format that was developed and standardized by the ISO/IEC MPEG and ITU-T VCEG.
RUN \
    DIR=/tmp/x265 && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    hg clone http://hg.videolan.org/x265 && cd x265/build/linux && ls && \
    sed -i "/-DEXTRA_LIB/ s/$/ -DCMAKE_INSTALL_PREFIX=\${PREFIX}/" multilib.sh && \
    sed -i "/^cmake/ s/$/ -DENABLE_CLI=OFF/" multilib.sh && \
    ./multilib.sh && \
    make -C 8bit install && \
    rm -rf ${DIR}

# Ogg project codecs use the Ogg bitstream format to arrange the raw, compressed bitstream into a more robust, useful form. 
RUN \
    DIR=/tmp/ogg && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/xiph/ogg/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz && \
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --enable-shared  && \
    make && \
    make install && \
    rm -rf ${DIR}

# Opus adalah sebuah format koding audio kualitas rendah yang dikembangkan oleh Internet Engineering Task Force (IETF) yang sangat cocok digunakan untuk aplikasi real-time interaktif dalam jaringan Internet.
RUN \
    DIR=/tmp/opus && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/xiph/opus/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz && \
    autoreconf -fiv && \
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}

# Vorbis is a general purpose audio and music encoding format contemporary to MPEG-4's AAC and TwinVQ, the next generation beyond MPEG audio layer 3.
RUN \
    DIR=/tmp/vorbis && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/xiph/vorbis/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz && \
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}

# Theora was Xiph.Org's first publicly released video codec, intended for use within the Foundation's Ogg multimedia streaming system. Theora is derived directly from On2's VP3 codec, adds new features while allowing it a longer useful lifetime.
RUN \
    DIR=/tmp/theora && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/xiph/theora/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz && \
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}

# WebM VP8/VP9 Codec SDK
RUN \
    DIR=/tmp/vpx && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://github.com/webmproject/libvpx/archive/master.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-vp8 --enable-vp9 --enable-vp9-highbitdepth --enable-pic --enable-shared \
    --disable-debug --disable-examples --disable-docs --disable-install-bins  && \
    make && \
    make install && \
    rm -rf ${DIR}

# WebP is a modern image format that provides superior lossless and lossy compression for images on the web.
RUN \
    DIR=/tmp/vebp && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://github.com/webmproject/libwebp/archive/master.tar.gz | \
    tar -zx --strip-components=1 && \
    # When building from git sources, you will need to run autogen.sh to generate configure script.
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --enable-shared  && \
    make && \
    make install && \
    rm -rf ${DIR}

# LAME is a high quality MPEG Audio Layer III (MP3) encoder licensed under the LGPL. Latest LAME release: v3.100 (October 2017)
RUN \
    apk add --no-cache subversion &&\
    DIR=/tmp/lame && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    svn checkout https://svn.code.sf.net/p/lame/svn/trunk/lame lame-svn &&\
    #curl -sLO https://sourceforge.net/code-snapshots/svn/l/la/lame/svn/lame-svn-r6474-trunk.zip --header "cookie: VISITOR=675b834b-420b-4acb-afbe-f6e0000abd8e; OAID=eb7e192a82138d4718de359f31af7466; _session_id=396e7aaa452cf383ef67e3544c33ec6ca337fd45881bef11c1f72562acc63e8e6fc85b5c609f2b96; sourceforge=521b81e7b37f7e31ec1b6287b0fc27359621a10agAJ9cQEoVQhfZXhwaXJlc3ECY2RhdGV0aW1lCmRhdGV0aW1lCnEDVQoH9gETAw4HAAAAhVJxBFgYAAAAcGVyc2lzdGVudF9xcy40ZmQ0YTU2YzQzcQWIVQNfaWRxBlUgMGM3MjA1Y2Q4YjNmNDg0OWE3NzQxZTdhOWY0ZmY1NDFxB1gGAAAAZGxoaXN0cQhdcQkofXEKKFUHcmVsZWFzZX1xCyhVBGRhdGVoA1UKB+QHGA8jCAAAAIVScQxVCnNmX2ZpbGVfaWRKc7D+AVUIZmlsZW5hbWVYJgAAAC9XaW5TQ1AvNS4xNy43L1dpblNDUC01LjE3LjctU2V0dXAuZXhldVUHcHJvamVjdH1xDShVCXNob3J0bmFtZVgGAAAAd2luc2NwVQVzZl9pZEpVTgEAVQRuYW1lWAYAAABXaW5TQ1B1dX1xDihVB3JlbGVhc2V9cQ8oVQRkYXRlaANVCgfdAg0IKB4AAACFUnEQVQpzZl9maWxlX2lkSrMscgBVCGZpbGVuYW1lWCYAAAAvZm9sZGVyc2l6ZS8yLjYvRm9sZGVyU2l6ZS0yLjYteDY0Lm1zaXVVB3Byb2plY3R9cREoVQlzaG9ydG5hbWVYCgAAAGZvbGRlcnNpemVVBXNmX2lkSoXxAQBVBG5hbWVYFwAAAEZvbGRlciBTaXplIGZvciBXaW5kb3dzdXVlVQNrZXlxElgkAAAANjc1YjgzNGItNDIwYi00YWNiLWFmYmUtZjZlMDAwMGFiZDhlcRNVBXByZWZzcRR9cRVVDl9hY2Nlc3NlZF90aW1lcRZHQdfgWlfWLr5VDl9jcmVhdGlvbl90aW1lcRdHQdffvTNK/Wl1Lg==" && \
    cd lame-svn && \
    ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --enable-shared --enable-nasm --disable-frontend && \
    make && \
    make install && \
    rm -rf ${DIR}

### xvid https://www.xvid.com/
RUN \
    XVID_VERSION=1.3.7 &&\
    DIR=/tmp/xvid && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://downloads.xvid.com/downloads/xvidcore-${XVID_VERSION}.tar.gz && \
    tar -zx -f xvidcore-${XVID_VERSION}.tar.gz && \
    cd xvidcore/build/generic && \
    ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" && \
    make && \
    make install && \
    rm -rf ${DIR}

# Fraunhofer FDK AAC is an open-source software library for encoding and decoding Advanced Audio Coding (AAC) format audio
RUN \
    DIR=/tmp/fdk-aac && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/mstorsjo/fdk-aac/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz &&\
    autoreconf -fiv && \
    ./configure --prefix="${PREFIX}" --enable-shared --datadir="${DIR}" && \
    make && \
    make install && \
    rm -rf ${DIR}

## openjpeg https://github.com/uclouvain/openjpeg
RUN \
    DIR=/tmp/openjpeg && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://github.com/uclouvain/openjpeg/archive/master.tar.gz | \
    tar -zx --strip-components=1 && \
    cmake -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
    make && \
    make install && \
    rm -rf ${DIR}

## freetype https://www.freetype.org/
RUN  \
    DIR=/tmp/freetype &&\
    mkdir -p ${DIR} &&\
    cd ${DIR} && \
    curl -sLO https://github.com/freetype/freetype2/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz && \
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}

# Vidstab is a video stabilization library which can be plugged-in with Ffmpeg and Transcode.
RUN  \
    DIR=/tmp/vid.stab && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/georgmartius/vid.stab/archive/v1.1.0.tar.gz && \
    tar -zx --strip-components=1 -f v1.1.0.tar.gz &&\
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
    make && \
    make install && \
    rm -rf ${DIR}

## fridibi https://www.fribidi.org/
RUN  \
    DIR=/tmp/fribidi && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/fribidi/fribidi/archive/master.tar.gz && \
    #echo ${FRIBIDI_SHA256SUM} | sha256sum --check && \
    tar -zx --strip-components=1 -f master.tar.gz && \
    #sed -i 's/^SUBDIRS =.*/SUBDIRS=gen.tab charset lib bin/' Makefile.am && \
    #./bootstrap --no-config --auto && \
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make -j1 && \
    make install && \
    rm -rf ${DIR}

## libxml2 - for libbluray
RUN \
    #LIBXML2_VERSION=2.9.10 &&\
    DIR=/tmp/libxml2 && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    #curl -sLO https://gitlab.gnome.org/GNOME/libxml2/-/archive/v${LIBXML2_VERSION}/libxml2-v${LIBXML2_VERSION}.tar.gz && \
    curl -sLO https://gitlab.gnome.org/GNOME/libxml2/-/archive/master/libxml2-master.tar.gz && \
    #echo ${LIBXML2_SHA256SUM} | sha256sum --check && \
    tar -xz --strip-components=1 -f libxml2-master.tar.gz && \
    #tar -xz --strip-components=1 -f libxml2-v${LIBXML2_VERSION}.tar.gz && \
    ./autogen.sh --prefix="${PREFIX}" --with-ftp=no --with-http=no --with-python=no && \
    make && \
    make install && \
    rm -rf ${DIR}

## fontconfig https://www.freedesktop.org/wiki/Software/fontconfig/
RUN  \
    apk add --no-cache --update gettext-dev &&\
    FONTCONFIG_VERSION=2.13.92 && \
    DIR=/tmp/fontconfig && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/freedesktop/fontconfig/archive/${FONTCONFIG_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f ${FONTCONFIG_VERSION}.tar.gz && \
    ./autogen.sh --prefix="${PREFIX}" --disable-static --enable-shared &&\
    #./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}

## libass https://github.com/libass/libass
RUN  \
    LIBASS_VERSION=0.13.7 && \
    DIR=/tmp/libass && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/libass/libass/archive/${LIBASS_VERSION}.tar.gz && \
    #echo ${LIBASS_SHA256SUM} | sha256sum --check && \
    tar -zx --strip-components=1 -f ${LIBASS_VERSION}.tar.gz && \
    ./autogen.sh && \
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}

# An open-source HEVC encoder
RUN \
    DIR=/tmp/kvazaar && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/ultravideo/kvazaar/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz && \
    ./autogen.sh && \
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}

# AOMedia Video 1 (AV1) is an open, royalty-free video coding format designed for video transmissions over the Internet.
RUN \
    DIR=/tmp/aom && \
    git clone --branch dev --depth 1 https://aomedia.googlesource.com/aom ${DIR} ; \
    cd ${DIR} ; \
    rm -rf CMakeCache.txt CMakeFiles ; \
    mkdir -p ./aom_build ; \
    cd ./aom_build ; \
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DBUILD_SHARED_LIBS=1 ..; \
    make ; \
    make install ; \
    rm -rf ${DIR}  

## libxcb (and supporting libraries) for screen capture https://xcb.freedesktop.org/
RUN \
    XORG_MACROS_VERSION=1.19.2 && \
    DIR=/tmp/xorg-macros && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://www.x.org/archive//individual/util/util-macros-${XORG_MACROS_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f util-macros-${XORG_MACROS_VERSION}.tar.gz && \
    ./configure --srcdir=${DIR} --prefix="${PREFIX}" && \
    make && \
    make install && \
    rm -rf ${DIR}

RUN \
    XPROTO_VERSION=2020.1 &&\
    DIR=/tmp/xproto && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    #         https://www.x.org/archive/individual/proto/xorgproto-2020.1.tar.gz
    curl -sLO https://www.x.org/archive/individual/proto/xorgproto-${XPROTO_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f xorgproto-${XPROTO_VERSION}.tar.gz && \
    ./configure --srcdir=${DIR} --prefix="${PREFIX}" && \
    make && \
    make install && \
    rm -rf ${DIR}

RUN \
    XAU_VERSION=1.0.9 &&\
    DIR=/tmp/libXau && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://www.x.org/archive/individual/lib/libXau-${XAU_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f libXau-${XAU_VERSION}.tar.gz && \
    ./configure --srcdir=${DIR} --prefix="${PREFIX}" && \
    make && \
    make install && \
    rm -rf ${DIR}

RUN \
    LIBPTHREAD_STUBS_VERSION=0.4 &&\
    DIR=/tmp/libpthread-stubs && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://xcb.freedesktop.org/dist/libpthread-stubs-${LIBPTHREAD_STUBS_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f libpthread-stubs-${LIBPTHREAD_STUBS_VERSION}.tar.gz && \
    ./configure --prefix="${PREFIX}" && \
    make && \
    make install && \
    rm -rf ${DIR}

RUN \
    XCBPROTO_VERSION=1.14 &&\
    DIR=/tmp/libxcb-proto && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://xcb.freedesktop.org/dist/xcb-proto-${XCBPROTO_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f xcb-proto-${XCBPROTO_VERSION}.tar.gz && \
    ACLOCAL_PATH="${PREFIX}/share/aclocal" ./autogen.sh && \
    ./configure --prefix="${PREFIX}" && \
    make && \
    make install && \
    rm -rf ${DIR}

RUN \
    LIBXCB_VERSION=1.14 &&\
    DIR=/tmp/libxcb && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://xcb.freedesktop.org/dist/libxcb-${LIBXCB_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f libxcb-${LIBXCB_VERSION}.tar.gz && \
    ACLOCAL_PATH="${PREFIX}/share/aclocal" ./autogen.sh && \
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}

## libbluray - Requires libxml, freetype, and fontconfig
RUN \
    DIR=/tmp/libbluray && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    git clone https://code.videolan.org/videolan/libbluray.git ${DIR} --depth 1 && git submodule update --init --recursive && \
    ./bootstrap && \
    ./configure --prefix="${PREFIX}" --disable-examples --disable-bdjava-jar --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR}

# ZeroMQ lightweight messaging kernel is a library which extends the standard socket interfaces with features traditionally provided by specialised messaging middleware products.
RUN \
    DIR=/tmp/libzmq && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/zeromq/libzmq/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz &&\
    ./autogen.sh && \
    ./configure --prefix="${PREFIX}" && \
    make && \
    make check && \
    make install && \
    rm -rf ${DIR}

# Secure Reliable Transport (SRT) is an open source transport technology that optimizes streaming performance across unpredictable networks, such as the Internet.
RUN \
    DIR=/tmp/srt && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/Haivision/srt/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz &&\
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
    make && \
    make install && \
    rm -rf ${DIR}

# libpng is the official Portable Network Graphics (PNG) reference library (originally called pnglib).
RUN \
    DIR=/tmp/png && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    git clone https://github.com/glennrp/libpng.git ${DIR} --depth 1 && \
    ./configure --prefix="${PREFIX}" && \
    make check && \
    make install && \
    rm -rf ${DIR}

# A library for ARIB STD-B24, decoding JIS 8 bit characters and parsing MPEG-TS stream.
RUN \
    DIR=/tmp/b24 && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/nkoriyama/aribb24/archive/master.tar.gz && \
    tar -xz --strip-components=1 -f master.tar.gz && \
    autoreconf -fiv && \
    ./configure CFLAGS="-I${PREFIX}/include -fPIC" --prefix="${PREFIX}" && \
    make && \
    make install && \
    rm -rf ${DIR}

RUN \
    apk add --no-cache --update gnutls-dev &&\
    DIR=/tmp/rtmpdump && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    #https://git.ffmpeg.org/rtmpdump.git
    git clone https://github.com/JudgeZarbi/RTMPDump-OpenSSL-1.1.git ${DIR} --depth 1 && \
    #curl -sLO https://dev.alpinelinux.org/archive/rtmpdump/rtmpdump-2.4_git20190330.tar.gz && \
    #tar -xz --strip-components=1 -f rtmpdump-2.4_git20190330.tar.gz && \
    make && \
    make -j1 prefix="${PREFIX}" install && \
    rm -rf ${DIR}

# ffmpeg.org
RUN \
    # Download ffmpeg
    FFMPEG_VERSION=snapshot && \
    DIR=/tmp/ffmpeg \
    && mkdir -p ${DIR} \
    && cd ${DIR} \
    && curl -sLO https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 \
    && tar -jx --strip-components=1 -f ffmpeg-${FFMPEG_VERSION}.tar.bz2 \
    # Compile
    && ./configure \
    --disable-debug \
    --disable-doc \
    --disable-ffplay \
    --enable-shared \
    --enable-avresample \
    --enable-libopencore-amrnb \
    --enable-libopencore-amrwb \
    --enable-gpl \
    --enable-libass \
    --enable-fontconfig \
    --enable-libfreetype \
    --enable-libvidstab \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libtheora \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libxcb \
    --enable-libx265 \
    --enable-libxvid \
    --enable-libx264 \
    --enable-nonfree \
    --enable-openssl \
    --enable-libfdk_aac \
    --enable-postproc \
    --enable-small \
    --enable-version3 \
    --enable-libbluray \
    --enable-libzmq \
    --extra-libs=-ldl \
    --prefix="${PREFIX}" \
    --enable-libopenjpeg \
    --enable-libkvazaar \
    --enable-libaom \
    --extra-libs=-lpthread \
    --enable-libsrt \
    --enable-libaribb24 \
    --enable-librtmp \
    --enable-protocol=file \
    --enable-protocol=rtmp \
    --extra-cflags="-I${PREFIX}/include" \
    --extra-ldflags="-L${PREFIX}/lib"\
    && make \
    && make install \
    && make tools/zmqsend && cp tools/zmqsend ${PREFIX}/bin/ \
    && make distclean \
    && hash -r \
    && cd tools \
    && make qt-faststart \
    && cp qt-faststart ${PREFIX}/bin \
    && cd / \
    && rm -rf ${DIR} \
    # Uninstall build deps
    && apk del ${buildDeps}

RUN \
    #Copy Miss
    LIBP='/usr/local/lib/' &&\
    cp -r /usr/lib/libintl.* ${LIBP} &&\
    cp -r /usr/lib/libexpat.* ${LIBP} &&\
    cp -r /usr/lib/libgomp.* ${LIBP} &&\
    #ldd command prints shared object dependencies ffmpeg, find lib tmp in dependencies link opt/ffmpeg
    ldd ${PREFIX}/bin/ffmpeg | grep ${PREFIX} | cut -d ' ' -f 3 | xargs -i cp {} ${LIBP} && \
    #link all lib in usr loc? 
    for lib in /usr/local/lib/*.so.*; do ln -s "${lib##*/}" "${lib%%.so.*}".so; done && \
    # Copy Tmp bin to Usr bin
    cp -r ${PREFIX}/bin/* /usr/local/bin/ && \
    cp -r ${PREFIX}/share/ffmpeg /usr/local/share/

FROM base AS release
ENV         LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64
CMD         ["--help"]
ENTRYPOINT  ["ffmpeg"]
COPY --from=build /usr/local /usr/local