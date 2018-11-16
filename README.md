# Hands-on Docker

## Step 2 : Using an existing Node.js image

So, you have docker up and running. It's time to use it to run our application !

We will write a `Dockerfile` to build an **image**, that will be used later to run a **container**.

Fortunately, Docker provides a [registry](https://registry.hub.docker.com/) of images, that can be used to avoid restarting from scratch each time. For example, it has a [Nginx image](https://registry.hub.docker.com/_/nginx/).

The documentation for the [Nginx image](https://registry.hub.docker.com/_/nginx/) give us an example `Dockerfile` :1

```
FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
```

The application listens by default on the **port 80**, so we can adjust the `Dokerfile` to:

```
FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 3000
```

The [`EXPOSE` instruction](https://docs.docker.com/reference/builder/#expose) is used to declare the ports on which services are listening. It will be used later to access the application from outside of the container.

Now that we have a `Dockerfile`, we need to build an image using the [`docker build`](https://docs.docker.com/reference/commandline/cli/#build) command :

```
docker build -t handsondocker .
```

* The `-t` option is used to define a tag (think name) to our image. Here, it will be named `handsondocker`
* The `.` at the end of the command is very important : it is the path that will be used as the *build context*. If your current directory is the root of the repository, then the path is the current directory (which is `.`). The *build context* is used to "upload" the application to the image.

This step can take quite a bit of time the first time, because Docker will download the base Nginx image from its [registry](https://registry.hub.docker.com/).

We can also use a [`.dockerignore`](https://docs.docker.com/reference/builder/#the-dockerignore-file) file to exclude some directories/files from being uploaded to the image, for example :

```
.git
```

If the git repository is quite big, and/or if there are some cache files, it will take more time to upload them to the image, but they won't be used. So it's better to exclude them (the same way you use a `.gitignore` to exclude files from being committed to a git repository).

So, let's check our image, with the `docker images` command :

```
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
handsondocker       latest              e3f98fc5f89e        23 minutes ago      109MB
nginx               latest              62f816a209e6        9 days ago          109MB
```

We can see our new `handsondocker` image, but we can also see the `nginx` image. This is because Docker use a system of *layers* for its images : every image is the sum of its "base" image and its own instructions.
If we upload web content to the image `handsondocker`, we'll see that our image is a few MB bigger than the base image: it is the size of the application.

In fact, each instruction in the `Dockerfile` result in a new image! You can see all images (including the "intermediate" images) but running the command `docker images -a` :

```
docker images -a
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
handsondocker       latest              e3f98fc5f89e        26 minutes ago      109MB
<none>              <none>              6c4f495bdc96        22 hours ago        89.2MB
lidl_web            latest              b6dbf8c63743        22 hours ago        89.2MB
<none>              <none>              3ebaefd32d0d        22 hours ago        89.2MB
<none>              <none>              126d79a5e383        22 hours ago        89.2MB
<none>              <none>              4b7011d6ce26        22 hours ago        78.2MB
<none>              <none>              259b8595c49a        22 hours ago        78.2MB
redis               5.0.1-alpine        28d359e5d4bb        6 days ago          40.9MB
nginx               latest              62f816a209e6        9 days ago          109MB
```

You can now re-run the `docker build -t handsondocker .` command, and it should execute very fast: because Docker has an intermediate image for each instruction, it use them as cache layers to speed up images building. So, if your instructions did not change, docker will use its cache. However, if an instruction change, docker will use its cache until the instruction, and then it will rebuild intermediate images (as the first time).

Note that if you want to force a rebuild of the image without using the cache, you can use the `--no-cache=true` option.

Ok, enough playing with the images - let's play with containers!

We will run a new container based on our image, using the [`docker run`](https://docs.docker.com/reference/commandline/cli/#run) command :

```
docker run --rm -it -p 8080:80 handsondocker
```

* the `--rm` option is used to auto-remove the container at the end (otherwise, Docker will just stop it, so that it can be started again - or manually removed if you don't need it anymore). If you are playing with Docker, and starting lots of containers, it is recommended to use the `--rm` option, to avoid keeping lots of unused containers around.
* the `-it` option is a shortcut for 2 options usually used together :
  * `-i` to enable the *interactive* mode : the standard input will be kept open
  * `-t` to enable the *tty* mode : it will allocate a *pseudo-TTY*

  You should use the `-it` option if you want to keep an interactive terminal when starting the container (otherwise, you won't be able to interact with it directly - you will need to use the `docker exec` command)
* the `-p 8080:80` option is used to map the port `8080` from the docker host to the port `80` of the container. This one is very important, because without it we won't be able to access our application from outside of the container!
* the last argument is the name of the image to use - `handsondocker`

You can check with the `docker ps` that the container is started :

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
11156f83978b        handsondocker       "nginx -g 'daemon of…"   4 seconds ago       Up 3 seconds        0.0.0.0:8080->80/tcp   dreamy_kirch
```

We can verify that the port `8080` has been mapped. And we can also see that the container has been given an auto-generated name `dreamy_kirch`, because we did not gave him one.

You can now use `Ctrl+C` to stop the container (it will be auto-removed thanks to the `--rm` option). If you run `docker ps` again it should be empty. Same for `docker ps -a` (which list all containers, even the stopped ones).

### Accessing container

Sometimes it will be needed to access inside container in order to execute some commands in order to check container contents. Docker provides the following commans:

```
docker exec -ti [container_id] bash
```

This instruction will allow you to access to the terminal inside container. From then on, you can move inside the container for executing your commands.


You can jump to the [step3](https://github.com/peppelin/hands-on-docker/tree/step3#readme) to find how to write your own image
