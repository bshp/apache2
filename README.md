#### Apache Web Server  
Designed to be run directly without having to create different dockerfiles for web applications that do not need some type of engine.
    
If you need either PHP or Tomcat:
    
PHP: [Walrus](https://github.com/bshp/walrus)  
Tomcat: [Firefly](https://github.com/bshp/firefly)  
    
#### Base OS:    
Ubuntu Server LTS
    
#### Packages:    
Updated weekly from the official upstream Ubuntu LTS image
````
apache2 
ca-certificates 
curl 
gnupg 
jq 
libapache2-mod-jk 
openssl 
tzdata 
unzip 
wget
````
#### Enabled Mods:
````
headers 
remoteip 
rewrite 
ssl 
unique_id
````
#### Disabled Mods:
````
info 
jk 
status
````
    
#### Environment Variables:    
    
Optional:    
````
APP_CACHE        = Sets your application cache directory, default: /var/cache
APP_DATA         = Set directory where apache can write to outside the web root, default: /var/www/data
CA_PATH          = URL or PATH to where CA Certificates can be found, prefixed with file: or url: , e.g url:https://www.example.com/ or file:/opt/certs
CA_FILTER        = the filter for certificate import, e.g "*_CA.crt"
CA_AUTO_UPDATE   = 1 (Import CERT_PATH certs into the OS and Java stores)
CA_UPDATE_JVM    = 0 (No affect if CA_AUTO_UPDATE is set to 1)
CA_UPDATE_KEYS   = 0 (No affect if CA_AUTO_UPDATE is set to 1)
CA_UPDATE_OS     = 1 (No affect if CA_AUTO_UPDATE is set to 1)
CERT_SUBJECT     = the subject for the server ssl keys, e.g "localhost"
CERT_UPDATE_KEYS = 0 to not update, 1 to force update
REWRITE_ENABLED  = 0 to disable, 1 to enable rewrite module, default: 1
REWRITE_CORS     = 0 do not add cors, 1 to add cors, uses mod_headers
REWRITE_DEFAULT  = 0 to not use, 1 to use, e.g rewrite all to ssl
REWRITE_EXCLUDE  = Exclude from rewrite, e.g "/path/ignore.html"
REWRITE_EXT      = Rewrite file extensions, e.g "php"
REWRITE_INDEX    = Rewrite everything to an entrypoint, setting this will override the REWRITE_EXT setting, e.g "index.php"
VADC_IP_ADDRESS  = address of load balancer, space seperated, e.g 192.168.100.105 192.168.0.105, default: 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16
VADC_IP_HEADER   = client ip header name, e.g X-Client-IP , default: X-Forwarded-For
````
Note:    
Some need to be set for certain functions when used direct with ociectl, see [Ocie Scripts](https://github.com/bshp/ocie/tree/main/src) for more info    
#### Direct:  
````
docker run --entrypoint /usr/local/bin/ociectl -d bshp/apache2:latest --run
````
#### Custom:  
Add at end of your entrypoint script either of:  
````
/usr/local/bin/ociectl --run;
````
````
apachectl -k start -D FOREGROUND;
````
    
#### Build:  
VERSION = Ubuntu version to build, e.g 22.04, 24.04
````
docker build . --pull --build-arg VERSION=22.04 --tag YOUR_TAG
````
    
