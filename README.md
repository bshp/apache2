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
    
see [Ocie Environment](https://github.com/bshp/ocie/blob/main/Environment.md) for more info
    
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
    
