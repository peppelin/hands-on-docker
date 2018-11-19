
# Hands-on Docker

## Step 6 : Running a load-balancer

Let's go one step further, and add a load-balancer in front of our 3 application instances. For example we can use [Nginx](https://www.nginx.com/). It has a [docker image](https://registry.hub.docker.com/_/nginx/) that can be used as reverse proxy and load-balancer.

The load-balancer will listen on a single port (**8000** in our case), and forward the incoming requests to any of the 3 configured "backend" application containers.

We will start by creating a new directory `load-balancer`, to store the Nginx configuration load-balancer/nginx.conf.

```
worker_processes 4;
events { worker_connections 1024; }
http {
    sendfile on;
    upstream app_servers {
        server app1:80;
        server app2:80;
        server app3:80;
    }
    server {
        listen 80;
        location / {
            if ($http_app = "app1"){
              proxy_pass http://app1;
            }
            if ($http_app = "app2"){
              proxy_pass http://app2;
            }
            if ($http_app = "app3"){
              proxy_pass http://app3;
            }
            if ($cookie_app = "app1"){
              proxy_pass http://app1;
            }
            if ($cookie_app = "app2"){
              proxy_pass http://app2;
            }
            if ($cookie_app = "app3"){
              proxy_pass http://app3;
            }
            proxy_pass         http://app_servers;
            proxy_redirect     off;
            proxy_set_header   Host $host;
            proxy_set_header   X-Real-IP $remote_addr;
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header   X-Forwarded-Host $server_name;
        }
    }
}
```

Here, we define that HAProxy listen on port 80, and forwards the requests to a group of "app_servers". We then list all servers (containers, in our case) that belongs to this group, with their name and host:port.
##### **NOTE**:
We've added the possibility to choose the app server by passing the header **app** with the name of the server, or doing the same with a cookie qith the same name and value.

We have two options now:

* Create a Dockerfile inside the "load-balancer" folder and describe the container configuration for the LB.
```
FROM nginx:latest
COPY nginx.conf /etc/nginx/nginx.conf

```
* Modify the `docker-compose` file in the root folder to mount the nginx.conf file inside the container. We'll also link the container to the 3 running apps.
```
lb:
    image: nginx:latest
    ports:
      - "8000:80"
    volumes:
      - ./load-balancer/nginx.conf:/etc/nginx/nginx.conf
    links:
      - app1
      - app2
      - app3
    restart: always
```
We'll use the second method, and the full `docker-compose` file will be as follows:
```
version: '2'

services:
  redis:
    image: redis
  app1:
    build: .
    hostname: app1
    links:
      - redis
  app2:
    build: .
    hostname: app2
    links:
      - redis
  app3:
    build: .
    hostname: app3
    links:
      - redis
  lb:
    image: nginx:latest
    ports:
      - "8000:80"
    volumes:
      - ./load-balancer/nginx.conf:/etc/nginx/nginx.conf
    links:
      - app1
      - app2
      - app3
    restart: always
```

We added a new container for nginx, using the official image and adding our config. This new container is linked to our 3 app containers, and map its port 8000 to the port 80 of the docker host.

Notice that we removed the port mapping from our app containers : we won't access them directly as before, but through the load-balancer container. To access to each app individually, we've configured the headers in the nginx conf.

Start everything with the `docker-compose up` command. You should now be able to use a single URL (on port 8000) that will be mapped to the load-balancer, and then to a random application instance, and finally to the redis instance.

You can now use `Ctrl+C` to stop everything (just note that this time, the containers won't be auto-destroyed. If you run `docker ps -a` you will notice that they are still around. You can remove them with the `docker rm` command if you want).

### Improvements

* We've changed the app base image from ubuntu to alpine linux.
* * The smaller the image, the better.
* * Alpine has less applications installed, so less things to update/check during security hardening.
* The load-balancer always restarts in case of crashing.
* The app and redis ports are not exposed, so it's not possible to connect from the outside.

