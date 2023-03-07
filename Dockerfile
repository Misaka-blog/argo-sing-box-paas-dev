FROM nginx:latest
EXPOSE 80
WORKDIR /app
USER root

COPY nginx.conf /etc/nginx/nginx.conf
COPY config.json ./
COPY entrypoint.sh ./

RUN apt-get update && apt-get install -y wget unzip iproute2 qrencode systemctl && \
    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    dpkg -i cloudflared.deb && \
    rm -f cloudflared.deb && \
    wget -N https://github.com/SagerNet/sing-box/releases/download/v1.2-beta5/sing-box-1.2-beta5-linux-amd64.tar.gz && \
    tar -x sing-box-1.2-beta5-linux-amd64/sing-box -f sing-box-1.2-beta5-linux-amd64.tar.gz && \
    mv sing-box-1.2-beta5-linux-amd64/sing-box sing-box && \
    rm -rf sing-box-1.2-beta5-linux-amd64 && rm -f sing-box-1.2-beta5-linux-amd64.tar.gz && \
    chmod -v 755 sing-box entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]