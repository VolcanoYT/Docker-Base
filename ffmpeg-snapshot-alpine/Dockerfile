FROM alpine:3.12

ENV  LD_LIBRARY_PATH=/usr/lib:/usr/lib64 \
     PREFIX=/usr \
     PKG_CONFIG_PATH="/usr/share/pkgconfig:/usr/lib/pkgconfig:/usr/lib64/pkgconfig" \
     tesdemo=1

RUN apk --no-cache add \
    # Protocol
    ca-certificates libcrypto1.1 libssl1.1 \ 
    # Basic Linux
    git bash bzip2 zlib curl tar expat linux-headers util-linux coreutils python3 \
    # v2
    libgcc libstdc++ gobject-introspection gettext gnutls fftw lcms2 orc \
    # lib image
    libexif giflib librsvg libimagequant libjpeg-turbo tiff &&\
    buildDeps=" \
    build-base \
    autoconf \
    automake \
    binutils \
    binutils-dev \
    cmake \
    libgomp \
    diffutils \
    file \
    g++ \
    gcc \
    gtk-doc\
    gperf \
    libtool \
    make \  
    yasm \
    nasm \
    mercurial \
    subversion \
    openssl-dev \
    zlib-dev \
    expat-dev \    
    gettext-dev \
    gnutls-dev \
    fftw-dev \
    giflib-dev \
    lcms2-dev \
    libexif-dev \
    libjpeg-turbo-dev \
    orc-dev \
    tiff-dev \
    gobject-introspection-dev \
    libimagequant-dev \
    librsvg-dev" && \
    apk add ${buildDeps}

RUN \
    # OpenCORE Framework implementation of Adaptive Multi Rate Narrowband and Wideband (AMR-NB and AMR-WB) speech codec. (TODO: need update)
    DIR=/tmp/opencore-amr && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://versaweb.dl.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.5.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-shared  && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # x264 is a free software library and application for encoding video streams into the H.264/MPEG-4 AVC compression format
    DIR=/tmp/x264 && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2 | \
    tar -jx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-shared --enable-pic --disable-cli && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # x265 is a library for encoding video into the High Efficiency Video Coding (HEVC/H. 265) video compression format that was developed and standardized by the ISO/IEC MPEG and ITU-T VCEG.
    DIR=/tmp/x265 && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/videolan/x265/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz && cd build/linux \
    sed -i "/-DEXTRA_LIB/ s/$/ -DCMAKE_INSTALL_PREFIX=\/${PREFIX}\/" multilib.sh && \
    sed -i "/^cmake/ s/$/ -DENABLE_CLI=OFF/" multilib.sh && \
    ./multilib.sh && \
    make -C 8bit install && \
    rm -rf ${DIR} &&\
    # Ogg project codecs use the Ogg bitstream format to arrange the raw, compressed bitstream into a more robust, useful form.
    DIR=/tmp/ogg && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/xiph/ogg/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz && \
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --enable-shared  && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # Opus adalah sebuah format koding audio kualitas rendah yang dikembangkan oleh Internet Engineering Task Force (IETF) yang sangat cocok digunakan untuk aplikasi real-time interaktif dalam jaringan Internet.
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
    rm -rf ${DIR} &&\
    # Vorbis is a general purpose audio and music encoding format contemporary to MPEG-4's AAC and TwinVQ, the next generation beyond MPEG audio layer 3.
    DIR=/tmp/vorbis && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/xiph/vorbis/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz && \
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR} &&\
    # Theora was Xiph.Org's first publicly released video codec, intended for use within the Foundation's Ogg multimedia streaming system. Theora is derived directly from On2's VP3 codec, adds new features while allowing it a longer useful lifetime.
    DIR=/tmp/theora && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/xiph/theora/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz && \
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --with-ogg="${PREFIX}" --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR} &&\
    # WebM VP8/VP9 Codec SDK
    DIR=/tmp/vpx && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://github.com/webmproject/libvpx/archive/master.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${PREFIX}" --enable-vp8 --enable-vp9 --enable-vp9-highbitdepth --enable-pic --enable-shared \
    --disable-debug --disable-examples --disable-docs --disable-install-bins  && \
    make && \
    make install && \
    rm -rf ${DIR} &&\
    # WebP is a modern image format that provides superior lossless and lossy compression for images on the web.
    DIR=/tmp/webp && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://github.com/webmproject/libwebp/archive/master.tar.gz | \
    tar -zx --strip-components=1 && \
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --enable-everything && \
    make && \
    make install && \
    rm -rf ${DIR} &&\
    # LAME is a high quality MPEG Audio Layer III (MP3) encoder licensed under the LGPL. Latest LAME release: v3.100 (October 2017)
    DIR=/tmp/lame && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    svn checkout https://svn.code.sf.net/p/lame/svn/trunk/lame lame-svn &&\
    cd lame-svn && \
    ./configure --prefix="${PREFIX}" --bindir="${PREFIX}/bin" --enable-shared --enable-nasm --disable-frontend && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # xvid https://www.xvid.com/
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
    rm -rf ${DIR} && \
    # Fraunhofer FDK AAC is an open-source software library for encoding and decoding Advanced Audio Coding (AAC) format audio
    DIR=/tmp/fdk-aac && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/mstorsjo/fdk-aac/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz &&\
    autoreconf -fiv && \
    ./configure --prefix="${PREFIX}" --enable-shared --datadir="${DIR}" && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # openjpeg https://github.com/uclouvain/openjpeg
    DIR=/tmp/openjpeg && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sL https://github.com/uclouvain/openjpeg/archive/master.tar.gz | \
    tar -zx --strip-components=1 && \
    cmake -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # freetype https://www.freetype.org/
    DIR=/tmp/freetype &&\
    mkdir -p ${DIR} &&\
    cd ${DIR} && \
    curl -sLO https://github.com/freetype/freetype2/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz && \
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR} &&\
    # Vidstab is a video stabilization library which can be plugged-in with Ffmpeg and Transcode.
    DIR=/tmp/vid.stab && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/georgmartius/vid.stab/archive/v1.1.0.tar.gz && \
    tar -zx --strip-components=1 -f v1.1.0.tar.gz &&\
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
    make && \
    make install && \
    rm -rf ${DIR} &&\
    # fridibi https://www.fribidi.org/
    DIR=/tmp/fribidi && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/fribidi/fribidi/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz && \
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make -j1 && \
    make install && \
    rm -rf ${DIR} &&\
    # libxml2 - for libbluray
    DIR=/tmp/libxml2 && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://gitlab.gnome.org/GNOME/libxml2/-/archive/master/libxml2-master.tar.gz && \
    tar -xz --strip-components=1 -f libxml2-master.tar.gz && \
    ./autogen.sh --prefix="${PREFIX}" --with-ftp=no --with-http=no --with-python=no && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # FONTCONFIG
    FONTCONFIG_VERSION=2.13.93 && \
    DIR=/tmp/fontconfig && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/freedesktop/fontconfig/archive/${FONTCONFIG_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f ${FONTCONFIG_VERSION}.tar.gz && \
    ./autogen.sh --prefix="${PREFIX}" --disable-static --enable-shared &&\
    make && \
    make install && \
    rm -rf ${DIR} &&\
    # libass https://github.com/libass/libass
    LIBASS_VERSION=0.13.7 && \
    DIR=/tmp/libass && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/libass/libass/archive/${LIBASS_VERSION}.tar.gz && \
    # echo ${LIBASS_SHA256SUM} | sha256sum --check && \
    tar -zx --strip-components=1 -f ${LIBASS_VERSION}.tar.gz && \
    ./autogen.sh && \
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # An open-source HEVC encoder
    DIR=/tmp/kvazaar && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/ultravideo/kvazaar/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz && \
    ./autogen.sh && \
    ./configure --prefix="${PREFIX}" --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # AOMedia Video 1 (AV1) is an open, royalty-free video coding format designed for video transmissions over the Internet.
    DIR=/tmp/aom && \
    mkdir -p ${DIR} && \
    cd ${DIR} &&\
    git clone --branch dev --depth 1 https://aomedia.googlesource.com/aom ${DIR} &&\    
    rm -rf CMakeCache.txt CMakeFiles &&\
    mkdir -p ./aom_build &&\
    cd ./aom_build &&\
    cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}" -DBUILD_SHARED_LIBS=1 .. &&\
    make &&\
    make install &&\
    rm -rf ${DIR} &&\
    # libxcb (and supporting libraries) for screen capture https://xcb.freedesktop.org/
    XORG_MACROS_VERSION=1.19.2 && \
    DIR=/tmp/xorg-macros && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://www.x.org/archive//individual/util/util-macros-${XORG_MACROS_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f util-macros-${XORG_MACROS_VERSION}.tar.gz && \
    ./configure --srcdir=${DIR} --prefix="${PREFIX}" && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # XPROTO
    XPROTO_VERSION=2020.1 &&\
    DIR=/tmp/xproto && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://www.x.org/archive/individual/proto/xorgproto-${XPROTO_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f xorgproto-${XPROTO_VERSION}.tar.gz && \
    ./configure --srcdir=${DIR} --prefix="${PREFIX}" && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # XAU
    XAU_VERSION=1.0.9 &&\
    DIR=/tmp/libXau && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://www.x.org/archive/individual/lib/libXau-${XAU_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f libXau-${XAU_VERSION}.tar.gz && \
    ./configure --srcdir=${DIR} --prefix="${PREFIX}" && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # LIBPTHREAD
    LIBPTHREAD_STUBS_VERSION=0.4 &&\
    DIR=/tmp/libpthread-stubs && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://xcb.freedesktop.org/dist/libpthread-stubs-${LIBPTHREAD_STUBS_VERSION}.tar.gz && \
    tar -zx --strip-components=1 -f libpthread-stubs-${LIBPTHREAD_STUBS_VERSION}.tar.gz && \
    ./configure --prefix="${PREFIX}" && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # XCBPROTO
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
    rm -rf ${DIR} && \
    # LIBXCB
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
    rm -rf ${DIR} && \
    # libbluray - Requires libxml, freetype, and fontconfig
    DIR=/tmp/libbluray && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    git clone --recurse-submodules --depth 1 https://code.videolan.org/videolan/libbluray.git ${DIR} &&\
    ./bootstrap && \
    ./configure --prefix="${PREFIX}" --disable-examples --disable-bdjava-jar --disable-static --enable-shared && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # ZeroMQ lightweight messaging kernel is a library which extends the standard socket interfaces with features traditionally provided by specialised messaging middleware products.
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
    rm -rf ${DIR} &&\
    # Secure Reliable Transport (SRT) is an open source transport technology that optimizes streaming performance across unpredictable networks, such as the Internet.
    DIR=/tmp/srt && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/Haivision/srt/archive/master.tar.gz && \
    tar -zx --strip-components=1 -f master.tar.gz &&\
    cmake \
     -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
     #-DCMAKE_INSTALL_LIBDIR=lib \
     -DCMAKE_BUILD_TYPE=None \
     #-DCMAKE_C_FLAGS="$CFLAGS" \
     -DENABLE_UNITTESTS=ON \
     -DENABLE_TESTING=ON \
     #-DENABLE_STATIC=OFF \
     -DCMAKE_SYSTEM_NAME=Linux \
     -DCMAKE_HOST_SYSTEM_NAME=Linux \
    . && \
    #ls && configure --prefix="${PREFIX}" && \
    make && \
    make install && \
    rm -rf ${DIR} && \
    # libpng is the official Portable Network Graphics (PNG) reference library (originally called pnglib).
    DIR=/tmp/png && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    git clone --depth 1 https://github.com/glennrp/libpng.git ${DIR} &&\
    #./autogen.sh && \
    ./configure --prefix="${PREFIX}" && \
    make && \
    make install && \
    rm -rf ${DIR} &&\
    # A library for ARIB STD-B24, decoding JIS 8 bit characters and parsing MPEG-TS stream.
    DIR=/tmp/b24 && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    curl -sLO https://github.com/nkoriyama/aribb24/archive/master.tar.gz && \
    tar -xz --strip-components=1 -f master.tar.gz && \
    autoreconf -fiv && \
    ./configure CFLAGS="-I${PREFIX}/include -fPIC" --prefix="${PREFIX}" && \
    make && \
    make install && \
    rm -rf ${DIR} &&\
    # RTMPDump
    DIR=/tmp/rtmpdump && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    git clone --depth 1 https://github.com/JudgeZarbi/RTMPDump-OpenSSL-1.1.git ${DIR} &&\
    make && \
    make -j1 prefix="${PREFIX}" install && \
    rm -rf ${DIR} &&\
    # libvips
    DIR=/tmp/libvips && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    git clone --depth 1 https://github.com/libvips/libvips.git ${DIR} &&\
    ./autogen.sh &&\
    ./configure --prefix="${PREFIX}" --enable-debug=no --without-gsf --with-imagemagick --with-webp &&\
    make && \
    make install && \
    rm -rf ${DIR} &&\
    # ffmpeg.org
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
    --enable-libopenjpeg \
    --enable-libkvazaar \
    --enable-libaom \
    --extra-libs=-lpthread \
    --enable-libsrt \
    --enable-libaribb24 \
    --enable-librtmp \
    --enable-protocol=file \
    --enable-protocol=rtmp \
    --prefix="${PREFIX}" \
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
    && rm -rf ${DIR}

RUN \
    apk --no-cache add python3 py3-pycryptodome py3-pycountry py3-requests py3-pysocks py3-websocket-client \
    py3-setuptools &&\
    DIR=/tmp/streamlink && \
    mkdir -p ${DIR} && \
    cd ${DIR} && \
    git clone --depth 1 https://github.com/streamlink/streamlink.git ${DIR} &&\
    python3 setup.py install && \
    rm -rf ${DIR}

CMD         ["--help"]
ENTRYPOINT  ["ffmpeg"]