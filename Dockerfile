FROM phusion/passenger-ruby21:0.9.17
# See documentation for using this image as a base here: https://github.com/phusion/passenger-docker

# Set correct environment variables.
ENV HOME /home/app/steamspan

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Copy the Gemfile and Gemfile.lock into the image.
# Temporarily set the working directory to where they are.
WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

# Enable nginx and passenger
RUN rm -f /etc/service/nginx/down

# Add nginx config for app
RUN rm /etc/nginx/sites-enabled/default
ADD container/app.conf /etc/nginx/sites-enabled/steamspan.conf
RUN mkdir $HOME

WORKDIR $HOME

# RUN ...commands to place your web app in /home/app/webapp...
ADD . $HOME
RUN chown app:app -R /home/app




