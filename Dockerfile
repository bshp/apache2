FROM ubuntu:jammy
    
LABEL org.opencontainers.image.authors="jason.everling@gmail.com"
    
ARG TZ=America/North_Dakota/Center
    
ENV OS_BASE=22.04
ENV OS_CODENAME=jammy
ENV OS_VERSION=2204
ENV OS_TIMEZONE=${TZ}
ENV APACHE_PID_FILE=/var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR=/var/run/apache2
ENV APACHE_LOCK_DIR=/var/lock/apache2
ENV APACHE_LOG=/var/log/apache2
ENV APACHE_CONF=/etc/apache2/conf-include
ENV APACHE_MODS=/etc/apache2/mods-include
ENV APACHE_SITES=/etc/apache2/sites-enabled
ENV APP_GROUP="www-data"
ENV APP_OWNER="www-data"
ENV APP_CACHE=/var/cache
ENV APP_DATA=/var/www/data
ENV APP_NAME=""
ENV APP_PARAMS=""
ENV APP_TYPE="apache"
ENV APP_UPDATE_PATH=""
ENV APP_UPDATE_AUTO=1
ENV APP_UPDATE_FAIL=0
ENV DH_PARAM_SIZE=2048
ENV CERT_PATH=""
ENV CERT_SUBJECT="localhost"
ENV CERT_FILTER="*_CA.crt"
ENV CERT_AUTO_UPDATE=0
ENV CERT_UPDATE_JVM=0
ENV CERT_UPDATE_KEYS=0
ENV CERT_UPDATE_OS=1
ENV REWRITE_CORS=1
ENV REWRITE_DEFAULT=0
ENV REWRITE_SKIP=1
ENV REWRITE_EXCLUDE=""
ENV REWRITE_EXT=""
ENV REWRITE_INDEX=""
ENV VADC_IP_ADDRESS="10.0.0.0/8 172.16.0.0/12 192.168.0.0/16"
ENV VADC_IP_HEADER="X-Forwarded-For"

# Initial Setup for httpd
RUN set -eux; \
    installPkgs='apache2 ca-certificates curl gnupg jq libapache2-mod-jk openssl tzdata wget'; \
    ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone; \
    apt-get update; \
    apt-get install -y --no-install-recommends $installPkgs; \
    service apache2 stop && a2enmod headers remoteip rewrite ssl unique_id; \
    a2dismod info jk status; \
    rm /etc/apache2/mods-available/jk.conf; \
    rm /etc/apache2/mods-available/jk.load; \
    rm -R /etc/libapache2-mod-jk; \
    openssl req -newkey rsa:2048 -x509 -nodes -keyout /etc/ssl/server.key -new -out /etc/ssl/server.pem -subj /CN=localhost -sha256 -days 3650; \
    openssl dhparam -out /etc/ssl/dhparams.pem ${DH_PARAM_SIZE}; \
    touch /etc/ssl/default.keys; \
    rm /var/log/apache2/*.log; \
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
