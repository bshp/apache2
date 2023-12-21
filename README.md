#### Apache Web Server  
Designed to be run as a base image for a web application.    
    
Base OS: Ubuntu Server LTS - Latest    
Apache2: Latest version for Ubuntu LTS, updated weekly    
    
#### Environment Variables:    
    
Optional:    
````
APP_CACHE        = Sets your application cache directory, default: /var/cache
APP_DATA         = Set directory where apache can write to outside the web root, default: /var/www/data
CERT_SUBJECT     = the subject for the server ssl keys, e.g "localhost"
CERT_FILTER      = the filter for certificate import, e.g "*_CA.crt"
CERT_UPDATE_KEYS = 0 to not update, 1 to force update
CERT_PATH        = URL or PATH to where CA Certificates can be found
CERT_AUTO_UPDATE = 1 (Import CERT_PATH certs into the OS and Java stores)
REWRITE_CORS     = 0 do not add cors, 1 to add cors, uses mod_headers
REWRITE_DEFAULT  = 0 to not use, 1 to use, e.g rewrite all to ssl
REWRITE_SKIP     = 0 to enable rewrite module, 1 to disable
REWRITE_EXCLUDE  = Exclude from rewrite, e.g "/path/ignore.html"
REWRITE_EXT      = Rewrite file extensions, e.g "php"
REWRITE_INDEX    = Rewrite everything to an entrypoint, setting this will override the REWRITE_EXT setting, e.g "index.php"
VADC_IP_ADDRESS  = address of load balancer, space seperated, e.g 192.168.100.105 192.168.0.105, default: 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16
VADC_IP_HEADER   = client ip header name, e.g X-Client-IP , default: X-Forwarded-For
````
Note:    
Some need to be set for certain functions, app-config, app-updater, cert-updater, see [Base Scripts](https://github.com/bshp/apache2/tree/master/src/usr/local/bin) for more info
    
#### Entrypoint: Add apache and optionally other commands
````
/usr/local/bin/app-cmd --certs --config;
apachectl -k start -D FOREGROUND;
````
#### Standalone: Use app-cmd    
    --certs = cert-updater
    --config = app-config
    --update = app-updater
    --run    = Run Application, starts apache2 or apache2+tomcat if it detected
````
docker run --entrypoint /usr/local/bin/app-cmd -e REWRITE_SKIP=0 -e REWRITE_DEFAULT=1 -d bshp/apache2:latest --config --run
````
    
#### Build:  
````
docker build . --tag YOUR_TAG
````
    