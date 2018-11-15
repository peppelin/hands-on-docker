# Hands-on Docker

## Step 1 : Installation

MacOS X:

* First, download the Docker from https://download.docker.com/mac/stable/Docker.dmg
  * Follow the [installation instructions](https://docs.docker.com/docker-for-mac/)
  
* And that is all. The package contains all you need!

Windows (the installation process depends on the Windows version):

* First, download the Docker daemon from https://download.docker.com/win/stable/InstallDocker.msi
  * Follow the installation instruction in the same page 

* And that is all. The package contains all you need!

## Basic commands

Befors messing with docker, we'll review some commands to make ourselves comfortable with the tools.

### Running an image

With docker, you can run containers, build from docker images. Let's run a basic linux container:
```
docker run alpine:3.8 sh
```
The first time, the docker service will search locally for the image name and if it's not there, it will download it from [docker hub](https://hub.docker.com).
You must specify the image you're using **alpine**, the tag **3.8** and the command to run **sh**.
If you try this command, the container exits and you can't do anything at all. That's because **sh** is interactive, and you need to specify that when launching the container.
```
docker run -ti --rm alpine:3.8 sh
```
**-ti** indicates that's a terminal interactive command.
**--rm** deletes the container once it finishes. This way, you don't need to clean up after using it.

### Checking the containers
To check if you have any container running, use the following command:
```
$ docker ps
docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                  NAMES
c192f2479b6e        redis               "docker-entrypoint.s…"   6 hours ago         Up 6 hours          6379/tcp               lidl_redis_1
1ca09b58ec5d        lidl_web            "python app.py"          6 hours ago         Up 6 hours          0.0.0.0:4000->80/tcp   lidl_web_1
```
From here, you can see the containers running, how much time they've been running. exposed ports, etc... but you can't see any stopped container.
To do so, use the command below:
```
$ docker ps -as
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                   PORTS                  NAMES               SIZE
c192f2479b6e        redis               "docker-entrypoint.s…"   6 hours ago         Up 6 hours               6379/tcp               lidl_redis_1        0B (virtual 94.9MB)
d7ce771cf210        redis               "docker-entrypoint.s…"   6 hours ago         Exited (0) 6 hours ago                          relaxed_tesla       0B (virtual 94.9MB)
1ca09b58ec5d        lidl_web            "python app.py"          6 hours ago         Up 6 hours               0.0.0.0:4000->80/tcp   lidl_web_1          422kB (virtual 89.6MB)
```
As you can see, **d7ce771cf210** has been exited 6 hours ago.

If you need to check for any information about a container, the commando

To delete any image, use the command rm
```
$ docker rm d7ce771cf210
d7ce771cf210
$ docker ps -as
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                   PORTS                  NAMES               SIZE
c192f2479b6e        redis               "docker-entrypoint.s…"   6 hours ago         Up 6 hours               6379/tcp               lidl_redis_1        0B (virtual 94.9MB)
1ca09b58ec5d        lidl_web            "python app.py"          6 hours ago         Up 6 hours               0.0.0.0:4000->80/tcp   lidl_web_1          422kB (virtual 89.6MB) 
```

### Checking images
Any container is built from an image. To check all the images you have, use:

```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
lidl_web            latest              b6dbf8c63743        6 hours ago         89.2MB
redis               5.0.1-alpine        28d359e5d4bb        5 days ago          40.9MB
redis               latest              415381a6cb81        5 days ago          94.9MB
alpine              3.5                 dc496f71dbb5        2 months ago        4MB
python              3.7.1-alpine        408808fb1a9e        3 weeks ago         78.2MB
alpine              3.8                 196d12cf6ab1        2 months ago        4.41MB
alpine              latest              196d12cf6ab1        2 months ago        4.41MB
```
Also, you can delete any image using
```
$ docker rmi dc496f71dbb5
Untagged: alpine:3.5
Untagged: alpine@sha256:b9f282308e8a557a5d8941e6515bc8fa840586ec59dd6284ba1f1e6c81654020
Deleted: sha256:dc496f71dbb587a32a007a0ffb420d1b35c55ec31cda99c0f5336954623f8368
Deleted: sha256:ffd20c106e18b5c7d69bcc6d90a16aea6329239547d8adcc8070d039196df25a
```

You can jump to the [step2 branch](https://github.com/peppelin/hands-on-docker/tree/step2#step-2) to find the `Dockerfile` and some explanations.
