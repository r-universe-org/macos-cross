ARG OSX_SDK="MacOSX13.1.sdk"

FROM ghcr.io/r-universe-org/base-image AS build
ARG OSX_SDK

# Download osxcross
RUN curl -sSOL https://github.com/tpoechtrager/osxcross/archive/refs/heads/master.tar.gz &&\
    tar xf master.tar.gz &&\
    rm -f master.tar.gz

WORKDIR /osxcross-master

# Download SDK
RUN curl -sSL "https://github.com/joseluisq/macosx-sdks/releases/download/13.1/${OSX_SDK}.tar.xz" -o "tarballs/${OSX_SDK}.tar.xz"

# Get osxcross dependencies
RUN apt-get update && tools/get_dependencies.sh

# Build osxcross
ENV OSX_VERSION_MIN=11.0
ENV UNATTENDED=1
ENV ENABLE_COMPILER_RT_INSTALL=1
ENV TARGET_DIR=/osxcross
RUN ./build.sh

# Build gcc (for gfortran)
ENV GCC_VERSION=12.2.0
ENV ENABLE_FORTRAN=1
RUN PATH=/osxcross/bin:$PATH:~/.local/bin ./build_gcc.sh


##### Actual Image #####

FROM ghcr.io/r-universe-org/base-image
ARG OSX_SDK
COPY --from=build /osxcross /osxcross
ENV MACOS_SDK_PATH="/osxcross/SDK/${OSX_SDK}"
ENV PATH="/osxcross/bin:${PATH}"
##ENV MACOSX_DEPLOYMENT_TARGET=11.0

RUN apt-get install -y clang

RUN ln -s x86_64-apple-darwin22-ar /osxcross/bin/ar && \
    ln -s /osxcross/bin/x86_64-apple-darwin22-ranlib /osxcross/bin/ranlib

RUN ln -s "${MACOS_SDK_PATH}/usr/bin/curl-config" /usr/local/bin/curl-config && \
    ln -s "${MACOS_SDK_PATH}/usr/bin/xml2-config" /usr/local/bin/xml2-config
