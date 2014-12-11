# dockerfile/nginx uses Ubuntu as a base image
FROM dockerfile/nginx
MAINTAINER Chris Han "chan@zehnergroup.com"

ADD ./dist /var/www
