#!/bin/bash -x
set -e

#Installing commonly needed pacakges
yum groupinstall "Development Tools" -y
yum install -y man nano telnet aws-cli parted wget bind-utils docker

#Installing and configuring nginx
yum install -y nginx
mv -f nginx.conf /etc/nginx/nginx.conf
chown nginx:nginx /etc/nginx/nginx.conf
cp nginx-app.conf /etc/nginx/conf.d/
cp nginx-redirect.conf /etc/nginx/conf.d/
cp 502.html /usr/share/nginx/html
cp 504.html /usr/share/nginx/html
printf '#!/bin/bash\nopenssl req -x509 -nodes -days 3650 -subj "/C=US/ST=Unknown/L=Unknown/O=Unknown/CN=Unknown" -newkey rsa:2048 -keyout /etc/nginx/ssl.key -out /etc/nginx/ssl.crt\nchmod 600 /etc/nginx/ssl.*' > /etc/rc3.d/S84ssl
chmod +x /etc/rc3.d/S84ssl
chkconfig nginx on

#Installing node.js using Linux binaries provided by Joyent
tar -xvf node-v0.10.43-linux-x64.tar.gz
mv node-v0.10.43-linux-x64/bin/* /usr/bin/
mv node-v0.10.43-linux-x64/lib/* /usr/lib/
npm install -g n
n 0.11
n 0.12
n 4.0
n 4.1
n 4.2
n 5.0
n 5.1
n 0.10

#Installing New Relic Linux server monitoring agent
rpm -Uvh https://download.newrelic.com/pub/newrelic/el5/i386/newrelic-repo-5-3.noarch.rpm
yum install newrelic-sysmond -y

#Creating app user and configuring
adduser app
usermod -L app
touch /var/log/app.log
chown app:app /var/log/app.log
echo "app soft nproc 1048576" >> /etc/security/limits.d/99-servo.conf
echo "app hard nproc 1048576" >> /etc/security/limits.d/99-servo.conf
echo "app soft nofile 1048576" >> /etc/security/limits.d/99-servo.conf
echo "app hard nofile 1048576" >> /etc/security/limits.d/99-servo.conf
echo "nginx soft nofile 1048576" >> /etc/security/limits.d/99-servo.conf
echo "nginx hard nofile 1048576" >> /etc/security/limits.d/99-servo.conf

#Installing node.js utilities
npm install -g forever
npm install -g newrelic

#Configuring Logrotate
mv servo-logrotate /etc/logrotate.d/
mv -f logrotate.conf /etc/
mv /etc/cron.daily/logrotate /etc/cron.hourly/

#Installing & Configuring AWS Logs
yum install awslogs -y
mv -f awslogs.conf /etc/awslogs/awslogs.conf
chkconfig awslogs on

#Trust internal CA
cat internal-certs.pem >> /etc/pki/tls/certs/ca-bundle.crt

#Installing and configuring dnsmasq
yum install -y dnsmasq
chkconfig dnsmasq on
echo 'prepend domain-name-servers 127.0.0.1;' >> /etc/dhcp/dhclient.conf
printf 'all-servers\ndns-forward-max=1024\ncache-size=1024\n' >> /etc/dnsmasq.conf
