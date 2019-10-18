FROM alpine:3.10.2

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# ****************************************
#   Install GNU C Library
#   https://github.com/sgerrand/alpine-pkg-glibc
# ****************************************
RUN BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    VERSION="2.30-r0" && \
    apk --no-cache --virtual .dependencies add ca-certificates wget && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget -q -O /tmp/glibc-$VERSION.apk $BASE_URL/$VERSION/glibc-$VERSION.apk && \
    wget -q -O /tmp/glibc-bin-$VERSION.apk $BASE_URL/$VERSION/glibc-bin-$VERSION.apk && \
    wget -q -O /tmp/glibc-i18n-$VERSION.apk $BASE_URL/$VERSION/glibc-i18n-$VERSION.apk && \
    apk add --no-cache /tmp/glibc-$VERSION.apk /tmp/glibc-bin-$VERSION.apk /tmp/glibc-i18n-$VERSION.apk && \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    rm /tmp/*.apk && \
    rm /root/.wget-hsts && \
    apk del .dependencies

# ****************************************
#   Install Miniconda3
# ****************************************
RUN wget -q --no-check-certificate -O /tmp/miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    ash /tmp/miniconda.sh -bfp /opt/conda && \
    ln -s /opt/conda/bin/* /usr/local/bin/ && \
    conda update conda && \
    conda clean --all -y && \
    rm /tmp/miniconda.sh && \
    rm -r /opt/conda/pkgs/*
