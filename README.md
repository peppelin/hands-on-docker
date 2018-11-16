
# Hands-on Docker

## Step 5 : Running multiple instances of the application

Now that we can easily describe our infrastructure in a single file, and start it with a single command, what about adding more application containers ? After all, that's one of the big benefit of Docker : running multiple containers of the same image, and being able to scale up easily.

We will edit the `docker-compose.yml` file to declare 3 application containers :

```
redis:
  image: redis
app1:
  build: .
  hostname: app1
  links:
  - redis
  ports:
  - "8080:80"
app2:
  build: .
  hostname: app2
  links:
  - redis
  ports:
  - "8081:80"
app3:
  build: .
  hostname: app3
  links:
  - redis
  ports:
  - "8083:80"
```

* the redis container is still the same
* each app container now has a custom hostname, to be able to identify them in the logs (easier to read than the default auto-generated ID of the containers)
* each app container has its port 3000 mapped to a different port on the docker host (from 3001 to 3003), because the docker host can't map the same port to multiple containers
* every app container has a link to the same redis container

Start everything with the `docker-compose up` command. You should now be able to access each application instance on a different port, and you can check on the `/logs` URL that all the logs coming from the different containers are stored on the same redis instance (you can see the hostname of each application container in the logs).

You can now use `Ctrl+C` to stop everything (just note that this time, the containers won't be auto-destroyed. If you run `docker ps -a` you will notice that they are still around. You can remove them with the `docker rm` command if you want).

Let's move to the final step, [step6](https://github.com/peppelin/hands-on-docker/tree/step6) for adding the HAProxy acting as a load balancer
