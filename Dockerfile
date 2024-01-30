# Ocie Version, e.g 22.04 unquoted
ARG OCIE_VERSION
    
# Optional: Change Timezone
ARG TZ=America/North_Dakota/Center
    
FROM bshp/ocie:${OCIE_VERSION}
    
LABEL org.opencontainers.image.authors="jason.everling@gmail.com"
    
ARG TZ
    
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
ENV APP_UPDATE_AUTO=1
ENV APP_UPDATE_FAIL=0
ENV APP_UPDATE_PATH=""
ENV DH_PARAM_SIZE=2048
ENV CA_PATH=""
ENV CA_FILTER="*_CA.crt"
ENV CA_AUTO_UPDATE=0
ENV CA_UPDATE_JVM=0
ENV CA_UPDATE_KEYS=0
ENV CA_UPDATE_OS=1
ENV CERT_PATH=""
ENV CERT_SUBJECT="localhost"
ENV OCIE_CONFIG=/etc/apache2
ENV REWRITE_CORS=1
ENV REWRITE_DEFAULT=0
ENV REWRITE_SKIP=1
ENV REWRITE_EXCLUDE=""
ENV REWRITE_EXT=""
ENV REWRITE_INDEX=""
ENV VADC_IP_ADDRESS="10.0.0.0/8 172.16.0.0/12 192.168.0.0/16"
ENV VADC_IP_HEADER="X-Forwarded-For"
    
# Initial Setup for Apache2
RUN <<"EOD" bash
    set -eu;
    # Add packages
    ocie --dhparams "-size ${DH_PARAM_SIZE}" --pkg "-add apache2,libapache2-mod-jk" --keys "-subject ${CERT_SUBJECT}";
    # Apache Cleanup
    a2enmod -q headers remoteip rewrite ssl unique_id >/dev/null;
    a2dismod -q info jk status >/dev/null;
    # Cleanup image, remove unused directories and files, etc..
    ocie --clean "-base -path /etc/apache2/mods-available/ -pattern 'jk.*' -dirs /etc/libapache2-mod-jk";
EOD
    
# Configs and Scripts
COPY --chown=root:root --chmod=0755 ./src/etc/apache2/ ./etc/apache2/
    
# Ensure Apache2 Starts
RUN <<"EOD" bash
    set -eu;
    echo "${OCIE_CONFIG}";
    echo "Validating Apache2 configuration";
    APACHE_TEST=$(ociectl --test);
    if [[ ! -z "$APACHE_TEST" ]];then
        echo "Validation: FAILED";
        echo "$APACHE_TEST";
        exit 1;
    else
        echo "Validation: SUCCESS";
    fi;
EOD
    
EXPOSE 80 443
    
CMD ["/bin/bash"]
