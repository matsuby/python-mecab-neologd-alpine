# syntax = docker/dockerfile:1.0-experimental
FROM python:3.9-alpine

LABEL maintainer="Kohei Matsubara <matsubygh@gmail.com>"

RUN apk update && \
    apk add --no-cache \
        bash \
        libgcc \
        libstdc++ \
        sudo && \
    apk add --no-cache --virtual .build-deps \
        bash \
        build-base \
        curl \
        git \
        openssl && \
    git clone --depth 1 https://github.com/taku910/mecab.git /tmp/mecab && \
    cd /tmp/mecab/mecab && \
    ./configure && \
    make && \
    make check && \
    make install && \
    git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git /tmp/neologd && \
    /tmp/neologd/bin/install-mecab-ipadic-neologd -n -y -a && \
    sed -ie 's#/usr/local/lib/mecab/dic/ipadic#/usr/local/lib/mecab/dic/mecab-ipadic-neologd#' /usr/local/etc/mecabrc && \
    pip3 install mecab-python && \
    apk del .build-deps && \
    rm -rf /tmp/mecab && \
    rm -rf /tmp/neologd
