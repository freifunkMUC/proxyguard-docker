# ProxyGuard Docker

A container image of <https://codeberg.org/eduVPN/proxyguard>, a "WireGuard over HTTPS" proxy.

## How to use

Plase also read ProxyGuard's docs on [Deployment](https://codeberg.org/eduVPN/proxyguard/src/branch/main/deploy.md) and [Technical docs](https://codeberg.org/eduVPN/proxyguard/src/branch/main/technical.md).

### HTTPS / TLS

While the inner WireGuard tunnel traffic is of course encrypted, you might still want to secure the outer parts using TLS.
For this you need a reverse proxy terminating the HTTPS traffic (and a TLS certificate).
Please pay special attention to the [Revers proxy section](https://codeberg.org/eduVPN/proxyguard/src/branch/main/deploy.md#reverse-proxy) of the ProxyGuard deployment guide, regarding "HTTP Upgrade" and WebSocket behaviour.

### With Docker Run

With the following command, the container will run in the host network namespace (unisolated), listen on `[::]:51821` for HTTPS-tunneled traffic from a ProxyGuard client, and forward the unpacked, raw WireGuard packets to `127.0.0.1:51820`, i.e. a WireGuard peer running on the bare host.

```sh
docker run --network host -e LISTEN_PORT=51821 -e TO=127.0.0.1:51820
```

### With Docker Compose

```yml
version: "3.0"
services:
  proxyguard:
    image: ghcr.io/dasskelett/proxyguard-docker:2
    restart: always
    network_mode: host
    environment:
      - "LISTEN_PORT=80"
      - "TO=[::1]:51820"
```
