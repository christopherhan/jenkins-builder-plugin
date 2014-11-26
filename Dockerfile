FROM ubuntu:14.04
MAINTAINER Chris Han "chan@zehnergroup.com"

RUN apt-get update -q && apt-get install -qqy curl

#RUN apt-get -qy install git
