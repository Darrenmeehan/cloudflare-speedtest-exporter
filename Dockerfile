FROM node:18.4.0-alpine3.15

ARG SPEEDTEST_VERSION=2.0.3

RUN adduser -D speedtest && \
    apk add --upgrade git

WORKDIR /app
COPY src/. .

RUN npm install git+https://github.com/Darrenmeehan/speed-cloudflare-cli.git && \
    apk add --upgrade py-pip && \
    pip install --no-cache-dir -r requirements.txt && \
    chown -R speedtest:speedtest /app && \
    rm -rf \
     /tmp/* \
     /app/requirements \
     /var/cache/apk/*

USER speedtest

CMD ["python3", "exporter.py"]

HEALTHCHECK --timeout=10s CMD wget --no-verbose --tries=1 --spider http://localhost:${SPEEDTEST_PORT:=9798}/