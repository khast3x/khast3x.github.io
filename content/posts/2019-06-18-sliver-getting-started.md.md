---
categories: tools
date: "2019-06-18T00:00:00Z"
description: Introduction to deploying golang-based cross platform C2, sliver!
excerpt_separator: <!--more-->
image: /assets/h8mail/dockertorrent.jpg
published: false
tags:
- offensive
- docker
- cloud
- golang
- C2
title: Getting started with sliver C2
---


In this post we'll be discovering the newly released [**sliver**](https://github.com/BishopFox/sliver) tool from BishopFox.  
From the original authors:   

*Sliver is a general purpose cross-platform implant framework that supports C2 over Mutual-TLS, HTTP(S), and DNS. Implants are dynamically compiled with unique X.509 certificates signed by a per-instance certificate authority generated when you first run the binary.*  
*The server, client, and implant all support MacOS, Windows, and Linux (and possibly every Golang compiler target but we've not tested them all).*

Keep in mind that this project is still in its alpha stage.  
Maintaining our testing environment siloed, especially regarding installed packages, is better for our work environment. We're going to use **Docker** to try out the server and deploy the C2.

# Getting sliver

We're first going to pull the repository locally, and build the Docker image on a remote server using `docker-machine`. If this isn't your setup, that's okay, we're going to keep things generic.  
You can learn about sliver installation methods in the [**official wiki**](https://github.com/BishopFox/sliver/wiki/Compile-From-Source).

Download:  
```bash
$ git clone https://github.com/BishopFox/sliver.git
$ cd sliver
```

The repository contains a convenient python script for Docker related deployments called `build.py`.  

The first time I tried building the image with `docker build`, my remote machine ran out of memory. I this server for other projects so it had leftover junk. I used the included `build.py` python script to clean up my remote Docker environment.

* *(Optional)* - Activate remote docker machine. Following this command, all `docker` related commands will be sent to our remote server. You can read more about it [here](https://docs.docker.com/machine/).
```bash
$ eval (docker-machine env default)
```

* Building the `sliver` Docker image with the included `build.py` script. Be careful, this argument removes all existing containers/images/volumes.  
```bash
$ python build.py --rm-all 
```

* Or build `sliver` with Docker directly:
```bash
$ docker build -t sliver .
```

There's going to be a lot happening in the building since it also builds Metasploit, so give it some time.  
Since we used the `docker-machine` eval method, all Docker related worked is done on the remote docker machine. 