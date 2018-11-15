# Hands-on Docker

Let's play with [Docker](https://www.docker.com/) : the goal of this *hands-on* is to learn how to use Docker to package and deploy a [Flask](http://flask.pocoo.org/), along with its dependencies (a [Redis](http://redis.io/) database) and a load-balancer ([Nginx](https://www.nginx.com/)).

Docker in a nutshell : a tool to build **images**, and run **containers** based on images. It can run multiple different containers based on the same image.

The flask web-application (provided) is very simple, and will just increases a counter for each visit in a Redis database. It also provides a `/host` endpoint to check how many visits for the given host (from the Redis database).

The *hands-on* is decomposed into the following steps :

* Install Docker and [Docker Compose](https://docs.docker.com/compose/).
* Use an existing image to check the possibilities.
* Write your own python image to package, deploy and run the application.
* Use Docker Compose to start both your application and a Redis container.
* Extend it to start multiples instances of your application.
* Extend it to run a load-balancer in front of all your instances.

At the end, you should be able to start a whole infrastructure (load-balancer + multiple instances of the application + a database instance) in a single command !

This repository has many branches :

* [step1](https://github.com/peppelin/hands-on-docker/tree/step1#readme) : installation instructions
* [step2](https://github.com/peppelin/hands-on-docker/tree/step2#readme) : Run an existing Docker Image and build your own simple image
* [step3](https://github.com/peppelin/hands-on-docker/tree/step3#readme) : writing your own python image
* [step4](https://github.com/peppelin/hands-on-docker/tree/step4#readme) : using docker compose
* [step5](https://github.com/peppelin/hands-on-docker/tree/step5#readme) : running multiple instances of the application
* [step6](https://github.com/peppelin/hands-on-docker/tree/step6#readme) : running a load-balancer
