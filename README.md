This app has been dockerized

To build image:

    docker build -t steamspan .

To run in development:

    docker run -i --name steamspan -d -p 3000:80 -e PASSENGER_APP_ENV=development steamspan
    docker run -i --name steamspan -d -p 3000:80 -v /Users/nmajor/dev/steamspan:/var/www/steamspan -e PASSENGER_APP_ENV=development steamspan

Open bash session inside container

    docker exec -t -i steamspan bash -l

Adding ENV variables to the docker image: https://github.com/phusion/passenger-docker#setting-environment-variables-in-nginx


docker kill steamspan
docker rm steamspan
docker build -t steamspan .
docker run -i --name steamspan -d -p 3000:80 -e PASSENGER_APP_ENV=development steamspan


docker kill steamspan
docker rm steamspan
docker build -t steamspan .
docker run -i --name steamspan -d -p 3000:80 -v /Users/nmajor/dev/steamspan:/var/www/steamspan -e PASSENGER_APP_ENV=development steamspan
docker exec -t -i steamspan bash -l

/usr/local/bundle/bin/unicorn -c config/unicorn.rb -E $RAILS_ENV -D
service nginx restart


APP_NAME="steamspan"
APP_ROOT="/var/www/$APP_NAME"
ENV=$RAILS_ENV
CMD="/usr/local/bundle/bin/unicorn -c config/unicorn.rb -E $ENV -D"
su - $USER -c "$CMD"




### Environmental Variables for Production
STEAM_API_KEY
DATABASE_NAME
DATABASE_HOST
DATABASE_USERNAME
DATABASE_PASSWORD
SECRET_KEY_BASE