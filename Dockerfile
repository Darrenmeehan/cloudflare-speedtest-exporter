FROM node:16.13.2-alpine3.15

ARG SPEEDTEST_VERSION=2.0.3

RUN adduser -D speedtest && \
    apk add --no-cache git=2.34.1

WORKDIR /app
COPY src/. .

RUN npm install git+https://github.com/Darrenmeehan/speed-cloudflare-cli.git#master && \
    apk add --no-cache py-pip=20.3.4 && \
    pip install --no-cache-dir -r requirements.txt && \
    chown -R speedtest:speedtest /app && \
    rm -rf \
     /tmp/* \
     /app/requirements \
     /var/cache/apk/*

USER speedtest

CMD ["python", "-u", "exporter.py"]

HEALTHCHECK --timeout=10s CMD wget --no-verbose --tries=1 --spider http://localhost:${SPEEDTEST_PORT:=9798}/