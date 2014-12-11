FROM ubuntu:14.04
MAINTAINER Chris Han "chan@zehnergroup.com"

ENV LOCAL_VARS_FILE stage.js

RUN apt-get update -q && apt-get install -qqy curl

# Install git
RUN apt-get -qy install git

################################
## Install build dependencies ##
################################

# Install rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 && curl -L https://get.rvm.io | bash -s stable

RUN /usr/local/rvm/bin/rvm requirements
RUN /usr/local/rvm/bin/rvm install 2.1.3
RUN /usr/local/rvm/scripts/rvm use 2.1.3 --default

ENV PATH /usr/local/rvm/rubies/ruby-2.1.3/bin:/usr/local/rvm/gems/ruby-2.1.3/bin:/usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV GEM_PATH /usr/local/rvm/gems/ruby-2.1.3:/.gem/ruby/2.1.0:/usr/local/rvm/rubies/ruby-2.1.3/lib/ruby/gems/2.1.0

# Install python-related packages for glue
RUN apt-get -qy install python-dev python-pip libjpeg62 libjpeg62-dev zlib1g-dev

# Install node and npm
RUN apt-get -qy install nodejs nodejs-legacy npm

# Install glue with pip
RUN pip install glue

# Install gems
RUN /usr/local/rvm/bin/rvm all do gem install --no-ri --no-rdoc compass --pre
RUN /usr/local/rvm/bin/rvm all do gem install --no-ri --no-rdoc susy
RUN /usr/local/rvm/bin/rvm all do gem install --no-ri --no-rdoc breakpoint
RUN /usr/local/rvm/bin/rvm all do gem install --no-ri --no-rdoc modular-scale
RUN /usr/local/rvm/bin/rvm all do gem install --no-ri --no-rdoc font-awesome-sass

# Install node pacakges
RUN npm install -g grunt
RUN npm install -g grunt-cli 
RUN npm install -g bower

#######################
## Build the project ##
#######################

# http://bitjudo.com/blog/2014/03/13/building-efficient-dockerfiles-node-dot-js/
ADD package.json /tmp/build/package.json
ADD app/bower.json /tmp/build/bower.json

WORKDIR /tmp/build
RUN npm install && bower install --allow-root

RUN mkdir -p /var/www/app 
RUN cp -a /tmp/build/node_modules /var/www && cp -a /tmp/build/bower_components /var/www/app

ADD . /var/www

WORKDIR /var/www

# Run glue to generate the spritesheet
RUN cd app/automation && ./glue.sh

# Copy over the local settings file
RUN cd app/scripts/constants && cp $LOCAL_VARS_FILE local.js

# Build the project
RUN grunt build

# Share the build files on the host
# This will then be commited to the container with Nginx
VOLUME ["/var/www/dist"]
