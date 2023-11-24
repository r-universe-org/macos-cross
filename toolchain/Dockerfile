# When bumping the SDK version you also need to change the darwin version in Makeconf and symlinks.
ARG OSX_SDK="MacOSX13.sdk"

FROM ghcr.io/r-universe-org/base-image AS build
ARG OSX_SDK

# Download osxcross
RUN curl -sSOL https://github.com/tpoechtrager/osxcross/archive/refs/heads/master.tar.gz &&\
    tar xf master.tar.gz &&\
    rm -f master.tar.gz

WORKDIR /osxcross-master

# Download SDK
RUN curl -sSL "https://github.com/joseluisq/macosx-sdks/releases/download/13.0/MacOSX13.0.sdk.tar.xz" -o "tarballs/${OSX_SDK}.tar.xz"

# Get osxcross dependencies
RUN apt-get update && tools/get_dependencies.sh

# Build osxcross
ENV OSX_VERSION_MIN=11.0
ENV UNATTENDED=1
ENV ENABLE_COMPILER_RT_INSTALL=1
ENV TARGET_DIR=/osxcross
ENV SDK_VERSION=13
RUN ./build.sh

# Build gcc (for gfortran)
ENV GCC_VERSION=13.2.0
ENV ENABLE_FORTRAN=1
ENV PATH="/osxcross/SDK/${OSX_SDK}/usr/bin:/osxcross/bin:${PATH}"

# Custom steps for arm64
RUN apt-get -y install automake libtool autoconf flex bison
COPY build_gcc.sh /osxcross-master/build_gcc.sh

RUN krb5-config --libs
RUN ./build_gcc.sh

##### Actual Image #####

FROM ubuntu:jammy
ARG OSX_SDK
COPY --from=build /osxcross /osxcross
ENV OSX_SDK_PATH=/osxcross/SDK/${OSX_SDK}
ENV PATH="${OSX_SDK_PATH}/usr/bin:/osxcross/bin:${PATH}"
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN apt-get update && apt-get install -y pkg-config clang llvm lld jq curl make libtool autoconf automake

# We use the host pkg-config (test with fftw R package)
RUN rm -v /osxcross/bin/*pkg-config && krb5-config --libs

RUN CRANLIBS=$(curl https://r-universe.dev/stats/sysdeps | jq --slurp -r '.[].packages | flatten[]') &&\
    apt-get install -y --no-install-recommends $CRANLIBS
