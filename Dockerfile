FROM ubuntu:14.04
MAINTAINER Chris Han "chan@zehnergroup.com"

# Simulate a built file
RUN mkdir -p /var/www/dist
ADD index.html /var/www/dist

# Share the build files on the host
# This will then be commited to the container with Nginx
VOLUME ["/var/www/dist"]

