FROM ubuntu:jammy
    
LABEL org.opencontainers.image.authors="jason.everling@gmail.com"
    
ARG TZ=America/North_Dakota/Center
    
ENV OS_BASE=22.04
ENV OS_CODENAME=jammy
ENV OS_VERSION=2204
ENV OS_TIMEZONE=${TZ}
    
# Initial Setup for httpd
RUN set -eux; \
    installPkgs='apache2 ca-certificates curl gnupg jq openssl tzdata wget'; \
    ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone; \
    apt-get update; \
    apt-get install -y --no-install-recommends $installPkgs; \
    service apache2 stop && a2enmod rewrite ssl unique_id; \
    a2enmod headers; \
    a2dismod info status; \
    openssl req -newkey rsa:2048 -x509 -nodes -keyout /etc/ssl/server.key -new -out /etc/ssl/server.pem -subj /CN=localhost -sha256 -days 3650; \
    openssl dhparam -out /etc/ssl/dhparams.pem 3072; \
    touch /etc/ssl/default.keys; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    echo "Installed Apache2 Web Server";
    
# Scripts and Configs
COPY ./src/ ./
    
RUN set -eux; \
    chown -R root:root /usr/local/bin; \
    chmod -R 0755 /usr/local/bin; \
    # Ensure apache2 can start
    apache2Test=$(apachectl configtest 2>&1); \
    apache2Starts=$(echo "$apache2Test" | grep 'Syntax OK'); \
    if [ -z "$apache2Starts" ];then \
        echo "Apache2 config test failed: $apache2Test"; \
        exit 1; \
    fi;
    
EXPOSE 80 443
    
CMD ["/bin/bash"]
