FROM docker.io/golang:1.25.5-alpine AS builder

RUN apk add make

WORKDIR /usr/local/src

ARG VERSION

RUN wget -O proxyguard.tar.gz https://codeberg.org/eduVPN/proxyguard/archive/$VERSION.tar.gz
RUN tar -xzf proxyguard.tar.gz

RUN cd proxyguard; CGO_ENABLED=0 make server


FROM docker.io/alpine:3.22.2

WORKDIR /usr/local/bin
COPY --from=builder /usr/local/src/proxyguard/proxyguard-server /usr/local/bin/

ENV TO=127.0.0.1:51820

ENV LISTEN_PORT=51821
EXPOSE $LISTEN_PORT/tcp

CMD proxyguard-server --listen [::]:$LISTEN_PORT --to $TO
