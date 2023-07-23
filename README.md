#### Apache Web Server  
Designed to be run as a base image for a web application.    
    
Base OS: Ubuntu Server LTS - Latest    
Apache2: Latest version for Ubuntu LTS, updated weekly    
    
You must have something like the below in your entrypoint
````
apachectl -k start -D FOREGROUND
````
Build:  
````
docker build . --tag YOUR_TAG
````
    