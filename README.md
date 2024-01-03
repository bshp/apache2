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
Some need to be set for certain functions when used direct with app-run, see [Base Scripts](https://github.com/bshp/apache2/tree/master/src/usr/local/bin) for more info    
#### Direct:  
````
docker run --entrypoint /usr/local/bin/app-run -e REWRITE_SKIP=0 -e REWRITE_DEFAULT=1 -d bshp/apache2:latest
````
#### Custom:  
Add at end of your entrypoint script either of:  
````
/usr/local/bin/app-run;
````
````
apachectl -k start -D FOREGROUND;
````
    
#### Build:  
VERSION = Ubuntu version to build, e.g 22.04, 24.04
````
docker build . --build-arg VERSION=22.04 --tag YOUR_TAG
````
    
