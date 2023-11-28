#### Apache Web Server  
Designed to be run as a base image for a web application.    
    
Base OS: Ubuntu Server LTS - Latest    
Apache2: Latest version for Ubuntu LTS, updated weekly    
    
Environment Variables:    
    
Optional:    
````
CA_URL = URL or PATH to where CA Certificates can be found, they must have the .crt extension, if valid, will be imported into the OS stores
VADC_IP_ADDRESS = address of load balancer, space seperated, e.g 192.168.100.105 192.168.0.105, default: 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16
VADC_IP_HEADER = client ip header name, e.g X-Client-IP , default: X-Forwarded-For
````
    
Scripts:    
    
cert-updater: Add/Update OS certificate store, requires environment variable CA_URL above, cert-updater -h for help.
````
/usr/local/bin/cert-updater -p "${CA_URL}"
````
    
Entrypoint: Add apache and optionally the cert-updater to your entrypoint script
````
/usr/local/bin/cert-updater -p "${CA_URL}";
apachectl -k start -D FOREGROUND
````
Build:  
````
docker build . --tag YOUR_TAG
````
    