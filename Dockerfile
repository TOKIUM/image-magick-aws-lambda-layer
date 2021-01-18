FROM lambci/lambda-base-2:build

ENV WORK_DIR /usr/local/work
ENV BUILD_DIR $WORK_DIR/build
ENV TARGET_DIR /opt

RUN mkdir -p $WORK_DIR

WORKDIR $WORK_DIR

# LCMS2
ENV LCMS2_VERSION 2.11
ENV LCMS2_SOURCE lcms2-${LCMS2_VERSION}.tar.gz
ENV LCMS2_MD5 598dae499e58f877ff6788254320f43e

RUN curl -LO https://downloads.sourceforge.net/lcms/${LCMS2_SOURCE} && \
  (test "$(md5sum ${LCMS2_SOURCE})" = "${LCMS2_MD5}  ${LCMS2_SOURCE}" || { echo 'Checksum Failed'; exit 1; }) && \
  tar xf ${LCMS2_SOURCE} && \
  cd lcms2* && \
  ./configure \
    --prefix=${BUILD_DIR} \
    --disable-shared \
    --enable-static && \
  make && \
  make install && \
  cd .. && \
  rm -rf lcms2*

# NASM (for libjpeg-turbo)
ENV NASM_VERSION 2.15.05
ENV NASM_SOURCE nasm-${NASM_VERSION}.tar.gz

RUN curl -LO https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/${NASM_SOURCE} && \
  tar xf ${NASM_SOURCE} && \
  cd nasm* && \
  ./autogen.sh && \
  ./configure \
    --prefix=${BUILD_DIR} && \
  make && \
  make install && \
  cd .. && \
  rm -rf nasm*

# libjpeg-turbo
ENV LIBJPEG_TURBO_VERSION 2.0.5
ENV LIBJPEG_TURBO_SOURCE libjpeg-turbo-${LIBJPEG_TURBO_VERSION}.tar.gz
ENV LIBJPEG_TURBO_MD5 3a7dc293918775fc933f81e2bce36464

RUN curl -LO https://downloads.sourceforge.net/libjpeg-turbo/${LIBJPEG_TURBO_SOURCE} && \
  (test "$(md5sum ${LIBJPEG_TURBO_SOURCE})" = "${LIBJPEG_TURBO_MD5}  ${LIBJPEG_TURBO_SOURCE}" || { echo 'Checksum Failed'; exit 1; }) && \
  tar xf ${LIBJPEG_TURBO_SOURCE} && \
  cd libjpeg* && \
  mkdir -p build && \
  cd build && \
  cmake .. \
    -DCMAKE_INSTALL_PREFIX=${BUILD_DIR} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_LIBDIR:PATH=lib \
    -DENABLE_SHARED=false \
    -DENABLE_STATIC=true && \
  make && \
  make install && \
  cd ../.. && \
  rm -rf libjpeg*

# libpng
ENV LIBPNG_VERSION 1.6.37
ENV LIBPNG_SOURCE libpng-${LIBPNG_VERSION}.tar.xz
ENV LIBPNG_MD5 015e8e15db1eecde5f2eb9eb5b6e59e9

RUN curl -LO http://prdownloads.sourceforge.net/libpng/${LIBPNG_SOURCE} && \
  (test "$(md5sum ${LIBPNG_SOURCE})" = "${LIBPNG_MD5}  ${LIBPNG_SOURCE}" || { echo 'Checksum Failed'; exit 1; }) && \
  tar xf ${LIBPNG_SOURCE} && \
  cd libpng* && \
  PKG_CONFIG_PATH=${BUILD_DIR}/lib/pkgconfig ./configure \
    CPPFLAGS=-I${BUILD_DIR}/include \
    LDFLAGS=-L$(BUILD_DIR)/lib \
    --disable-dependency-tracking \
    --disable-shared \
    --enable-static \
    --prefix=${BUILD_DIR} && \
  make && \
  make install && \
  cd .. && \
  rm -rf libpng*

# bzip2
ENV BZIP2_VERSION 1.0.6
ENV BZIP2_SOURCE bzip2-${BZIP2_VERSION}.tar.gz
ENV BZIP2_MD5 00b516f4704d4a7cb50a1d97e6e8e15b

RUN curl -LO http://prdownloads.sourceforge.net/bzip2/${BZIP2_SOURCE} && \
  (test "$(md5sum ${BZIP2_SOURCE})" = "${BZIP2_MD5}  ${BZIP2_SOURCE}" || { echo 'Checksum Failed'; exit 1; }) && \
  tar xf ${BZIP2_SOURCE} && \
  cd bzip2* && \
  make libbz2.a && \
  make install PREFIX=${BUILD_DIR} && \
  cd .. && \
  rm -rf bzip2*

# libtiff
ENV LIBTIFF_VERSION 4.1.0
ENV LIBTIFF_SOURCE tiff-${LIBTIFF_VERSION}.tar.gz
ENV LIBTIFF_MD5 2165e7aba557463acc0664e71a3ed424

RUN curl -LO http://download.osgeo.org/libtiff/${LIBTIFF_SOURCE} && \
  (test "$(md5sum ${LIBTIFF_SOURCE})" = "${LIBTIFF_MD5}  ${LIBTIFF_SOURCE}" || { echo 'Checksum Failed'; exit 1; }) && \
  tar xf ${LIBTIFF_SOURCE} && \
  cd tiff* && \
  PKG_CONFIG_PATH=${BUILD_DIR}/lib/pkgconfig ./configure \
    CPPFLAGS=-I${BUILD_DIR}/include \
    LDFLAGS=-L$(BUILD_DIR)/lib \
    --disable-dependency-tracking \
    --disable-shared \
    --enable-static \
    --prefix=${BUILD_DIR} && \
  make && \
  make install && \
  cd .. && \
  rm -rf tiff*

# libwebp
ENV LIBWEBP_VERSION 1.1.0
ENV LIBWEBP_SOURCE libwebp-${LIBWEBP_VERSION}.tar.gz
ENV LIBWEBP_MD5 35831dd0f8d42119691eb36f2b9d23b7

RUN curl -L https://github.com/webmproject/libwebp/archive/v${LIBWEBP_VERSION}.tar.gz -o ${LIBWEBP_SOURCE} && \
  (test "$(md5sum ${LIBWEBP_SOURCE})" = "${LIBWEBP_MD5}  ${LIBWEBP_SOURCE}" || { echo 'Checksum Failed'; exit 1; }) && \
  tar xf ${LIBWEBP_SOURCE} && \
  cd libwebp* && \
  ./autogen.sh && \
  PKG_CONFIG_PATH=${BUILD_DIR}/lib/pkgconfig ./configure \
    CPPFLAGS=-I${BUILD_DIR}/include \
    LDFLAGS=-L$(BUILD_DIR)/lib \
    --disable-dependency-tracking \
    --disable-shared \
    --enable-static \
    --prefix=${BUILD_DIR} && \
  make && \
  make install && \
  cd .. && \
  rm -rf libwebp*

# OpenJPEG
ENV OPENJP2_VERSION 2.3.1
ENV OPENJP2_SOURCE openjp2-${OPENJP2_VERSION}.tar.gz
ENV OPENJP2_MD5 3b9941dc7a52f0376694adb15a72903f

RUN curl -L https://github.com/uclouvain/openjpeg/archive/v${OPENJP2_VERSION}.tar.gz -o ${OPENJP2_SOURCE} && \
  (test "$(md5sum ${OPENJP2_SOURCE})" = "${OPENJP2_MD5}  ${OPENJP2_SOURCE}" || { echo 'Checksum Failed'; exit 1; }) && \
  tar xf ${OPENJP2_SOURCE} && \
  cd openjpeg* && \
  mkdir -p build && \
  cd build && \
  PKG_CONFIG_PATH=${BUILD_DIR}/lib/pkgconfig cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${BUILD_DIR} \
    -DBUILD_SHARED_LIBS:bool=off \
    -DBUILD_CODEC:bool=off && \
  make clean && \
  make install && \
  cd ../.. && \
  rm -rf openjpeg*

# XML
ENV LIBXML2_VERSION 2.9.10
ENV LIBXML2_SOURCE libxml2-${LIBXML2_VERSION}.tar.gz
ENV LIBXML2_PATCH libxml2-security.patch
ENV LIBXML2_MD5 10942a1dc23137a8aa07f0639cbfece5

RUN curl -L http://xmlsoft.org/sources/libxml2-${LIBXML2_VERSION}.tar.gz -o ${LIBXML2_SOURCE} && \
  curl -L http://www.linuxfromscratch.org/patches/blfs/svn/libxml2-${LIBXML2_VERSION}-security_fixes-1.patch -o ${LIBXML2_PATCH} && \
  (test "$(md5sum ${LIBXML2_SOURCE})" = "${LIBXML2_MD5}  ${LIBXML2_SOURCE}" || { echo 'Checksum Failed'; exit 1; }) && \
  tar xf ${LIBXML2_SOURCE} && \
  cd libxml2* && \
  patch -p1 -i ../${LIBXML2_PATCH} && \
  sed -i '/if Py/{s/Py/(Py/;s/)/))/}' python/{types.c,libxml.c} && \
  PKG_CONFIG_PATH=${BUILD_DIR}/lib/pkgconfig ./configure \
    CPPFLAGS=-I${BUILD_DIR}/include \
    LDFLAGS=-L${BUILD_DIR}/lib \
      --disable-dependency-tracking \
      --disable-shared \
      --enable-static \
      --with-history \
      --with-python=/usr/bin/python3 \
      --prefix=${BUILD_DIR} && \
  make && \
  make install && \
  cd .. && \
  rm -rf libxml2*

# ImageMagick
ENV IMAGEMAGICK_VERSION 7.0.10-58
ENV IMAGEMAGICK_SOURCE ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz
ENV IMAGEMAGICK_SHA256 1c3baaa5c0f9fb11ca35ac00e513226671061a53b46449f98e0ad9b0d92edd99

RUN curl -LO https://imagemagick.org/download/${IMAGEMAGICK_SOURCE} && \
  (test "$(sha256sum ${IMAGEMAGICK_SOURCE})" = "${IMAGEMAGICK_SHA256}  ${IMAGEMAGICK_SOURCE}" || { echo 'Checksum Failed'; exit 1; }) && \
  tar xf ${IMAGEMAGICK_SOURCE} && \
  cd ImageMagick* && \
  PKG_CONFIG_PATH=${BUILD_DIR}/lib/pkgconfig ./configure \
    CPPFLAGS=-I${BUILD_DIR}/include \
    LDFLAGS=-L${BUILD_DIR}/lib \
    --disable-dependency-tracking \
    --disable-shared \
    --enable-static \
    --prefix=${TARGET_DIR} \
    --enable-delegate-build \
    --without-modules \
    --disable-docs \
    --without-magick-plus-plus \
    --without-perl \
    --without-x \
    --disable-openmp && \
  make clean && \
  make all && \
  make install && \
  cd .. && \
  rm -rf ImageMagick*

CMD ["/opt/bin/identify"]
