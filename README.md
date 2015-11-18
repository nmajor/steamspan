This app has been dockerized

### Docker usage notes

To build image:

    docker build -t steamspan .

To run in development:

    docker run -i --name steamspan -d -p 3000:80 -e PASSENGER_APP_ENV=development steamspan
    docker run -i --name steamspan -d -p 3000:80 -v /Users/nmajor/dev/steamspan:/var/www/steamspan -e PASSENGER_APP_ENV=development steamspan

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



docker kill steamspan
docker rm steamspan
docker run -i --name steamspan -d -p 80:80 -v /Users/nmajor/dev/steamspan:/var/www/steamspan -e PASSENGER_APP_ENV=production -e SECRET_KEY_BASE=60aaa2d2840b0d9df9c6393b3e4176bf1d9cdd635da8d68abfc063be0d7115f9978c220714b98976caa1cab73a043604f63483c90e5c0eaa2fa9b3cdf4151c5b -e STEAM_API_KEY=1C6CC8CE1C1F16D68DD8096CF9DB9390 -e PRODUCTION_DATABASE_NAME=steamspan_production -e PRODUCTION_DATABASE_HOST=72.2.119.40 -e PRODUCTION_DATABASE_USERNAME=steamspan -e PRODUCTION_DATABASE_PASSWORD=8fjSD0fkw0lfslnqpmk923nklw steamspan