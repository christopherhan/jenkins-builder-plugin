FROM ubuntu:14.04
MAINTAINER Chris Han "chan@zehnergroup.com"

# Simulate a built file
RUN mkdir dist
ADD index.html dist

# Share the build files on the host
# This will then be commited to the container with Nginx
VOLUME ["./dist"]
