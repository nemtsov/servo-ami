# Servo AMI

This is an example of the AMI behind all applications deployed using the PaaS.
Installs and configures the following:
* NodeJs
* Node Newrelic agent
* logrotate
* dnsmasq
* nginx
* AWS Cloudwatch logs


## Nginx Configuration

* Nginx is listening to ports 443 and 444.
* Port 443 proxies traffic over to port 53840.
* Port 444 redirects traffic to port 443.
* Nginx has a 10 second timeout before serving the 504 page.


## Related Repos
* [servo-docs](http://github.com/dowjones/servo-docs)
* [servo-core](http://github.com/dowjones/servo-core)
* [servo-gateway](http://github.com/dowjones/servo-gateway)
* [servo-console](http://github.com/dowjones/servo-console)
