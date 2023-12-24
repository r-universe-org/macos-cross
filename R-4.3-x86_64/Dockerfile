FROM ghcr.io/r-universe-org/macos-cross:toolchain

ARG R_BRANCH=4.3
ARG DARWIN=darwin22

RUN \
    curl https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc > /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
    echo "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" >> /etc/apt/sources.list.d/cran.list  && \
    apt-get update && \
    apt-get -yq install --no-install-recommends cpio r-recommended language-pack-en-base &&\
    apt-get clean

RUN mkdir /tmp/xq && cd /tmp/xq &&\
    curl -fsSOL https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.5/XQuartz-2.8.5.pkg &&\
    xar -x -f XQuartz-2.8.5.pkg &&\
    cd XQuartzComponent.pkg &&\
    gzip -cd Payload | cpio -idm &&\
    mv opt/X11 /opt/ &&\
    cd / && rm -Rf /tmp/xq

# Download and extract MacOS R
RUN mkdir -p /macos/r &&\
	curl -sSL https://mac.r-project.org/big-sur/last-success/R-${R_BRANCH}-branch-x86_64.tar.xz -o R.tar.xz &&\
	tar xf R.tar.xz --strip-components=4 -C /macos/r R.framework/Versions/${R_BRANCH}-x86_64/Resources &&\
	rm -f R.tar.xz

# Download and extract static CRAN libraries
RUN curl -ssOL https://github.com/r-universe-org/cranlibs/releases/download/2023-12-18/cranlibs-x86_64.tar.xz &&\
	tar xf cranlibs-x86_64.tar.xz -C / &&\
	rm -f cranlibs-x86_64.tar.xz &&\
	ln -s /opt/R/x86_64 /macos/usr

## Set RSPM as the default repo to get precompiled packages
RUN RPROFILE=$(R RHOME)/etc/Rprofile.site && \
    echo 'options(repos = c(CRAN = "https://p3m.dev/cran/__linux__/jammy/latest"))' >> "$RPROFILE" && \
    echo 'options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version$platform, R.version$arch, R.version$os)))' >> "$RPROFILE"

# Put some stuff on the path. There {DARWIN} depends on SDK version.
RUN ln -s x86_64-apple-${DARWIN}-ar /osxcross/bin/ar && \
    ln -s /osxcross/bin/x86_64-apple-${DARWIN}-strip /osxcross/bin/strip && \
    ln -s /osxcross/bin/x86_64-apple-${DARWIN}-ranlib /osxcross/bin/ranlib && \
    ln -s /osxcross/bin/x86_64-apple-${DARWIN}-install_name_tool /osxcross/bin/install_name_tool &&\
    rm /opt/R/x86_64/bin/pkg-config && ln -s /opt/R/x86_64/bin/*-config /osxcross/bin/


## This would override Linux configs with MacOS. But this may break the host?
#RUN cp -R /macos/r/etc/* /usr/lib/R/etc
#RUN cp -R /macos/r/share/make/* /usr/share/R/share/make

# Prep host R for cross compiling
COPY osxcross-x86_64.Makeconf /usr/lib/R/etc/Makeconf
COPY uname-x86_64.sh /osxcross/bin/uname
COPY pkg-config-x86_64.sh /osxcross/bin/pkg-config
COPY build-package-x86_64.sh /osxcross/bin/build-package

# Fixup hardcoded things ppm
RUN sed -i "s/darwin22/${DARWIN}/g" /usr/lib/R/etc/Makeconf

# Override R_PLATFORM variable
RUN sed -i 's/x86_64-pc-linux-gnu/x86_64-apple-darwin20/g' /etc/R/Renviron

# Overrides for the Linux Renviron
ENV MACOS_BUILD=1
ENV MACOSX_DEPLOYMENT_TARGET=11.0
ENV LIBRARY_PATH=/opt/R/x86_64/lib:${LIBRARY_PATH}
ENV R_CONFIGURE_FLAGS="--build=x86_64-pc-linux-gnu --host=x86_64-apple-${DARWIN}"
ENV _R_SHLIB_STRIP_=true
ENV R_STRIP_SHARED_LIB="strip -x"
ENV R_STRIP_STATIC_LIB="strip -S"

# Fix some R packages
#ENV PROJ_GDAL_DATA_COPY=TRUE
ENV ARROW_R_DEV=TRUE
ENV LIBARROW_BINARY=darwin-x86_64-openssl-1.1

# Experiment: force linking errors
RUN sed -i "s/-undefined dynamic_lookup//g" /usr/lib/R/etc/Makeconf &&\
    sed -i '/^LIBR =/ s/$/ $(LIBR1)/' /usr/lib/R/etc/Makeconf

# Make bash the system shell (just like on MacOS) because some packages assume this
RUN ln -sf /bin/bash /bin/sh
