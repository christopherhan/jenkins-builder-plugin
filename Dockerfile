FROM ubuntu:14.04
MAINTAINER Chris Han "chan@zehnergroup.com"

RUN apt-get update -q && apt-get install -qqy curl

# Install git
RUN apt-get -qy install git

RUN apt-get -qy install nginx
