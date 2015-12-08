FROM ruby:2.2.0
RUN apt-get update -qq
RUN apt-get install -y build-essential curl git imagemagick libmagickwand-dev libcurl4-openssl-dev nodejs postgresql-client

# Copy the Gemfile and Gemfile.lock into the image.
# Temporarily set the working directory to where they are.
WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

# Set correct environment variables.
ENV APP_HOME /var/apps/steamspan

ADD container/containerbuddy/containerbuddy /sbin/containerbuddy

RUN mkdir -p $APP_HOME

ADD . $APP_HOME
WORKDIR $APP_HOME
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace

CMD ["rails","server","-b","0.0.0.0"]