# CATS AND DOGS APPLICATION STACK

This exercise is a voting app about cats and dogs. Application is composed of 4 components:
- vote service: interface from where users are going to vote for cats and dogs
- result service: interface from where users are going to see the results
- database service: a postgres database to store results
- cache service: a redis server used to cache results between voting service and worker service
- worker service: a service necessary to implement some functionality between redis and database. 

To see the application's flow look at the architecture.png file in the repo.
To see how application looks like look at the app.gif file in the repo.


In this exercise you're not going to write Dockerfiles from scratch. For postgres and redis we will use ready images, other applications have already their Dockerfiles. 

## docker-compose
In the docker-compose you must create 2 networks:
- frontend
- backend

### Votes Service
0. This is an application written in python with framework flask.
1. This application has 2 Dockerfile, one for production, one for development. So you must Build the image using ./vote directory and Dockerfile.dev for development environment, not Dockerfile(that is for production).
2. Override container's cmd from docker-compose. it must launch `python app.py`
3. Since its a development environment, mount the `./vote` app to the `/app` dir of container. So if we do any change to the python code, we can see it immediatly on running container.
4. This service must be connected to both frontend network and backend network.
5. You must find out yourself, which port application listens on and expose that port on port 5000 of your host.

### Result Service
0. This is an application written in node js.
1. Build it with ./result directory and override its command from docker-compose. It must launch `nodemon server.js` command.
2. Again, for the development environment, mount `./result` directory to `/app` dirrectory inside container.
3. You must find out which port applications listens and expose that port on port 5001 of your host.
4. This application must expose also port 5858 to same port. It's necessary for its functionality.
4. This service also  must be connected to both frontend network and backend network.

### Worker Service
0. For the worker service it was possible to use a .Net application or a java application. We decided to use the one with java. 
1. So you must build application with `./worker` directory and Dockerfile.j file that you find inside the `./worker`. As usual we will build with multistage. Dockerfile has the first stage to generate jar, you must add second stage to:
- use an openjdk image with a compatible version to the image used to build application in the first stage 
- copy jar from the first stage
- copy docker-entrypoint.sh from host to same place where you copy jar
- set entrypoint to launch docker-entrypoint.sh for the container
2. This application must be connected to only backend network. Evaluate if this application needs to expose a port.

### Redis service
0. Use `redis:alpine` image and expose its port with same port.
1. Service name must be `redis` because worker app is configured to connect to the address `redis`. 
2. This application must be connected to only backend network.

### Postgres Service:
0. User `postgres:9.4` image
1. Service name must be `db` because worker app is configured to connect to the address `db`. 
2. Set postgres username and password as "postgres".
3. Mount a volume to persist postgres data.
4. This application must be connected to only backend network.
