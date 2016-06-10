This app has been dockerized
blah
### Docker usage notes

To build image:

    docker build -t steamspan .

To run in development:

    docker run -i --name steamspan -d -p 80:80 -e RAILS_ENV=development steamspan
    docker run -i --name steamspan -d -p 80:80 -v /Users/nmajor/dev/steamspan:/var/app/steamspan -e PASSENGER_APP_ENV=development steamspan

Open bash session inside container

    docker exec -t -i steamspan bash -l

Adding ENV variables to the docker image: https://github.com/phusion/passenger-docker#setting-environment-variables-in-nginx


Build and reload container
    docker kill steamspan
    docker rm steamspan
    docker build -t steamspan .
    docker run -i --name steamspan -d -p 3000:80 -e PASSENGER_APP_ENV=development steamspan


### Tagging and pushing docker image

    docker tag [IMAGE_ID] nmajor/steamspan:latest

    docker login

    docker push nmajor/steamspan


### Environmental variables needed for production docker container

STEAM_API_KEY
DATABASE_NAME
DATABASE_HOST
DATABASE_USERNAME
DATABASE_PASSWORD
SECRET_KEY_BASE

### Google analytics link tracking

https://developers.google.com/analytics/devguides/collection/analyticsjs/events#overview
onclick="ga('send', 'event', 'Amazon Affiliate Link', 'Action label', 'Action Value');"
