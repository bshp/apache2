# Ocie Version, e.g 22.04 unquoted
ARG OCIE_VERSION
    
FROM bshp/ocie:${OCIE_VERSION}
    
ENV APACHE_LOG=/var/log/apache2 \
    APACHE_CONF=/etc/apache2/conf-include \
    APACHE_MODS=/etc/apache2/mods-include \
    APACHE_SITES=/etc/apache2/sites-enabled \
    OCIE_CONFIG=/etc/apache2 \
    APP_TYPE="apache" \
    APP_GROUP="www-data" \
    APP_OWNER="www-data" \
    APP_HOME=/var/www/html \
    APP_DATA=/var/www/data \
    CA_ENABLED=1 \
    CA_UPDATE_OS=1 \
    CERT_ENABLED=1 \
    REWRITE_ENABLED=0 \
    REWRITE_CORS=1 \
    REWRITE_DEFAULT=0 \
    REWRITE_EXCLUDE="" \
    REWRITE_EXT="" \
    REWRITE_INDEX=""
    
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
