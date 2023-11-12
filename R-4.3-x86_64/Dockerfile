FROM ghcr.io/r-universe-org/macos-cross:toolchain

ARG R_BRANCH=4.3
ARG DARWIN=darwin22.2

ENV MACOS_BUILD=1
ENV MACOSX_DEPLOYMENT_TARGET=11.0
ENV LIBRARY_PATH=/opt/R/x86_64/lib:${LIBRARY_PATH}
ENV R_CONFIGURE_FLAGS="--build=x86_64-pc-linux-gnu --host=x86_64-apple-${DARWIN}"
ENV R_BUILD_FLAGS="--no-test-load --configure-args='--build=x86_64-pc-linux-gnu --host=x86_64-apple-${DARWIN}'"
ENV _R_SHLIB_STRIP_=true

# Download and extract MacOS R
RUN mkdir -p /macos/r &&\
	curl -sSL https://mac.r-project.org/big-sur/last-success/R-${R_BRANCH}-branch-x86_64.tar.xz -o R.tar.xz &&\
	tar xf R.tar.xz --strip-components=4 -C /macos/r R.framework/Versions/${R_BRANCH}-x86_64/Resources &&\
	rm -f R.tar.xz

# Download and extract static CRAN libraries
RUN curl -ssOL https://github.com/r-universe-org/cranlibs/releases/download/2023-08-10/cranlibs.tar.xz &&\
	tar xf cranlibs.tar.xz -C / &&\
	rm -f cranlibs.tar.xz &&\
	ln -s /opt/R/x86_64 /macos/usr


# Put some stuff on the path. Note that 'darwin22' depends on SDK version.
RUN ln -s x86_64-apple-${DARWIN}-ar /osxcross/bin/ar && \
    ln -s /osxcross/bin/x86_64-apple-${DARWIN}-ranlib /osxcross/bin/ranlib && \
    ln -s /osxcross/bin/x86_64-apple-${DARWIN}-install_name_tool /osxcross/bin/install_name_tool

# Prep host R for cross compiling
COPY osxcross-x86_64.Makeconf /usr/lib/R/etc/Makeconf
COPY uname-x86_64.sh /osxcross/bin/uname
COPY pkg-config-x86_64.sh /osxcross/bin/pkg-config
RUN cp -R /macos/r/etc /usr/lib/R/etc
RUN cp -R /macos/r/share/make /usr/share/R/share/make
RUN sed -i "s/darwin22/${DARWIN}/g" /usr/lib/R/etc/Makeconf
