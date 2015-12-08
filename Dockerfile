FROM ruby:2.2.0
RUN apt-get update -qq
RUN apt-get install -y build-essential curl git imagemagick libmagickwand-dev libcurl4-openssl-dev nodejs postgresql-client

# Copy the Gemfile and Gemfile.lock into the image.
# Temporarily set the working directory to where they are.
WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

# Install and configure nginx
RUN apt-get install -y nginx
RUN rm -rf /etc/nginx/sites-available/default
ADD container/nginx.conf /etc/nginx/sites-available/default

ADD container/containerbuddy/containerbuddy /sbin/containerbuddy

ENV APP_HOME /var/app/steamspan
ENV APP_SHARED /var/app/shared
RUN mkdir -p $APP_HOME
RUN mkdir -p $APP_SHARED/pids $APP_SHARED/sockets $APP_SHARED/log

ADD . $APP_HOME
WORKDIR $APP_HOME
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace

CMD ["bundle", "exec", "puma"]

RUN service nginx restart