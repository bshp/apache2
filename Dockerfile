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
# Ocie
ENV OCIE_CONFIG=/etc/apache2
ENV APP_TYPE="apache"
ENV APP_GROUP="www-data"
ENV APP_OWNER="www-data"
ENV APP_HOME=/var/www/html
ENV APP_DATA=/var/www/data
ENV CA_ENABLED=1
ENV CA_UPDATE_OS=1
ENV CERT_ENABLED=1
ENV REWRITE_ENABLED=0
ENV REWRITE_CORS=1
ENV REWRITE_DEFAULT=0
ENV REWRITE_EXCLUDE=""
ENV REWRITE_EXT=""
ENV REWRITE_INDEX=""
    
# Initial Setup for Apache2
RUN <<"EOD" bash
    set -eu;
    # Add packages
    ocie --dhparams "-size ${DH_PARAM_SIZE}" --pkg "-add apache2,libapache2-mod-jk" --keys "-subject ${CERT_SUBJECT} -tag default.keys";
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
