FROM ubuntu:14.04
MAINTAINER Chris Han "chan@zehnergroup.com"

# Share the build files on the host
# This will then be commited to the container with Nginx
VOLUME ["./dist"]

