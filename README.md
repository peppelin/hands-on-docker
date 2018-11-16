# Hands-on Docker

## Step 4 : Using Docker Compose

We will now extend our setup to include a [Redis](http://redis.io/) instance. There are many ways to do that :

* install Redis in our application's container. We won't do that, because that's against the philosophy of Docker : *each container should have a single responsibility*
* create a new image and container to run a Redis instance, and [link it](https://docs.docker.com/userguide/dockerlinks/) to our existing application's container.

We will start by running a Redis container, using a ready-to-use [Redis image](https://registry.hub.docker.com/_/redis/) :

```
docker run --rm -ti -p 6379:6379 --name redis-container redis
```

Docker will download the redis image form its registry, and start a new container named `redis-container`, with its port 6379 (the default redis port) mapped to the docker host.

Note that it is important to give a name to the redis container, because we will need it later to make it accessible from the application container.

To test it, you can use `telnet` to talk to the redis instance :

```
telnet localhost 6379
```

you should see `Escape character is '^]'.` Enter `ping` and hit enter : redis should reply you with a nice `pong`. Good ! You can now `quit`.

So we can access our application which is on one container on port 3000, and redis which is on another container on port 6379. But how do we make our application talk to redis?

Docker provides a mechanism to [link](https://docs.docker.com/userguide/dockerlinks/) containers together, which is very easy to use :

* just add the `--link` option to the `docker run` command
* docker will add some entries in `/etc/hosts` and export some environment variables, so that you can access the other container easily

Let's start a new application container, but linked to the redis container already running :

```
docker run --rm -it -p 8080:80 --link redis-container:redis handsondocker
```

The `redis-container:redis` syntax is used to say that the container named `redis-container` should be aliased `redis` on the newly started container.

If you go to the application's homepage using your browser, you will notice that the connection to redis instance has been established!

So, how is it working ? when starting the application container, docker did add a line in the `/etc/hosts` file to declare a host named `redis` (the alias we defined), pointing to the IP of the redis container. And the application's configuration use the `redis` hostname to connect to redis. Bingo ! If you decide to links the containers with a different alias for the redis container, the application won't be able to talk to the redis instance, even though the 2 containers are well linked.

While it is working, you might have noticed that the setup is a little complex, with command-line getting bigger and bigger. So, instead of doing all this by hand, we will now use a higher-level tool name [Docker Compose](https://docs.docker.com/compose/), that can work with multiple containers at once.

Stop all your containers (you can even remove them with the `docker rm` command), and we will start again from a clean `docker-compose.yml` file, that will be used to define our current infrastructure :

* 1 Redis container, based on the [Redis image](https://registry.hub.docker.com/_/redis/)
* 1 application container, based on a custom image built from the current directory, with a link to the redis container, and a port mapping (so you can access the application from the outside of the container)

The `docker-compose.yml` is pretty simple (for the moment) :

```
redis:
  image: redis
app:
  build: .
  links:
  - redis
  ports:
  - "8080:80"
```

* we have declared a `redis` container, based on the `redis` image
* and an `app` container, based on an image built from the `Dockerfile` in the current directory, linked to the `redis` container, and mapping the port 8080 on the docker host to the port 80 on the container.

Notice that we didn't declare ports mapping for the redis container : we only need to declare them if we want to access the services from the outside. Here, the redis port will be accessed only from the app container.

We can now start the whole infrastructure with a single command !

```
docker-compose up
```

Docker Compose will rebuild our application image (giving it a new name), and start the 2 containers. You should be able to access the application like before, and make sure the logs are being written to the redis instance.

You can now use `Ctrl+C` to stop everything (just note that this time, the containers won't be auto-destroyed. If you run `docker ps -a` you will notice that they are still around. You can remove them with the `docker rm` command if you want).

Now let's take a look on other useful Docker Compose commands:

* To execute a custom file located in other directory or with other name (not the default one)

```
docker-compose -f [my_compose_file] up
```

* To execute your docker compose in a "background" mode:

```
docker-compose up -d
```

* To view logs:
```
docker-compose logs
```

* To stop all containers defined by your "docker_compose" file:
```
docker-compose stop
```

* To stop and remove all containers defined by your "docker_compose" file:
```
docker-compose down
```

You can jump to the [step5](https://github.com/peppelin/hands-on-docker/blob/step5/) to learn how to run multiple oinstances of your application
