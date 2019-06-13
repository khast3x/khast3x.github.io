---
layout: post
title: 'Password Breaches with Docker and h8mail'
description: Pushing all the heavy lifting of breach studies to the cloud
image: /assets/h8mail/dockertorrent.jpg
categories: h8mail
excerpt_separator: <!--more-->
published: true
tags:
  - h8mail
  - OSINT
  - password
  - breach
  - haveibeenpwned
  - leak
  - docker
  - cloud
---

In this tutorial, we're going to move downloading and searching operations to the cloud to speed things up.  
We'll achieve this using a **torrent downloader container**, the **h8mail container** and **a shared volume**. For demonstration purposes, we'll be studying the Breach Compilation.

<!--more-->


![](https://i.postimg.cc/CxK85jf7/facebook-cover-photo-2dockertorrent.jpg)

# Getting started

You'll first need a working Docker environment on a remote server. This can be achieved by:
*  choosing to boot into a ready-made Docker "image" with your cloud service provider
*  installing Docker on a vanilla Ubuntu server.    
Here is the documentation for [installing docker on Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/).  
Here is a detailed community tutorial for getting started with [Docker on DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04).

*Make sure the server you're renting has enough storage space for our downloads. In this tutorial ~60GB should be okay.*

To test that everything is working correctly, SSH into your new instance and run this docker "hello-world":


```bash
$ docker run -it hello-world
```

And get the following output:
```bash
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
c1eda109e4da: Pull complete 
Digest: sha256:0e11c388b664df8a27a901dce21eb89f11d8292f7fca1b3e3c4321bf7897bffe
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.
[...]
```

We're set for the next steps.


----

# Downloading the breach


We're first going to launch our torrent container with basic password protection, a volume and a port.

```bash
$ docker run -d --name ct -p 3000:3000 -e AUTH='h8admin:h8p4ss' -v dl:/downloads jpillora/cloud-torrent
```

* In case some of you are discovering Docker

| Argument | Description|
|--|--|
|-d|daemon mode|
|--name ct | container name is `ct`|
|-p 3000:3000| map container port 3000 with host port 3000|
|-e AUTH="admin:pass"| this is where you set authentication details|
|-v dl:/downloads|we're mapping a volume called `dl` to `/downloads` in the container|

Once the command is executed, you can check your running containers with `docker ps`.  

Head over to your browser and navigate to `http://your-docker-ip:3000`, authenticate and paste the [BreachCompilation magnet link](https://gist.github.com/scottlinux/9a3b11257ac575e4f71de811322ce6b3#gistcomment-2298792).  

If unsure of your IP, you can run `curl icanhazip.com`.  

*Tip: Since the torrent has a huge directory tree, I suggest you shrink the web interface's torrent directory list to avoid loading them in your browser window*

![dl](https://i.postimg.cc/PNnJ8QJB/screely-1559870254049.png)


## Volume sharing

We are using a shared volume to allow h8mail to parse the downloaded torrent. You can [read more](https://www.digitalocean.com/community/tutorials/how-to-share-data-between-docker-containers) about it, basically we create a volume called `dl` when running the `-v` argument for the torrent container.  
You can view more information about this volume by typing:  
```bash
$ docker volume inspect dl 
```

Which you give you something like this:  
```json
[
    {
        "CreatedAt": "2019-06-07T42:02:30Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/dl/_data",
        "Name": "dl",
        "Options": null,
        "Scope": "local"
    }
]
```


You'll notice the "Mountpoint" path. You can `cd` to that directory to interact directly with your data.  

For the purpose of demonstration we'll be using the volume through Docker's abstraction layer, but you know where to find your files on the Docker host.


----

# Searching the breach

Once the BreachCompilation is downloaded, you can stop the torrent container:  
```bash
$ docker rm -f ct
```

At this point, the BreachCompilation torrent lives in the "dl" volume we created & mounted to the torrent download path.  

You can check it out by going to the previously mentioned Mountpoint path:

```bash
root@docker-host:$ docker volume inspect dl
[
    {
        "CreatedAt": "2019-06-07T01:02:30Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/dl/_data",
        "Name": "dl",
        "Options": null,
        "Scope": "local"
    }
]
root@docker-host:$ cd /var/lib/docker/volumes/dl/_data
root@docker-host:$ ls -la
total 644
drwxr-xr-x 3 root root    4096 Jun  7 01:02 .
drwxr-xr-x 3 root root    4096 Jun  7 01:00 ..
drwxr-x--- 4 root root    4096 Jun  7 01:27 BreachCompilation

```

We're going to run the auto-built h8mail docker container, mount the dl volume with the BreachCompilation, and seamlessly search for our targets:

```bash
docker run -it -v dl:/dl kh4st3x00/h8mail -t john.smith@gmail.com -bc /dl/BreachCompilation/ -sk
```

If all goes well, you'll be searching through the BreachCompilation torrent like a real cloud ninja


**Done.**

----

# Downloading files instead of torrents

This also works with generic files.  

You can use [JDownloader](https://hub.docker.com/r/jlesage/jdownloader-2/#quick-start) as a Docker image, and share its volume with h8mail.

![](https://i.postimg.cc/d075wfdF/DM6-NGm-OU8-AANf-Zu.png)

More advanced but worth looking into, you can also use [aria2](https://github.com/abcminiuser/docker-aria2-with-webui) with a Web UI, and share the download volume with h8mail.  

![](https://raw.githubusercontent.com/mayswind/AriaNg-WebSite/master/screenshots/desktop.png)


----

# Closing remarks

Using the cloud to move around those large datasets is increasingly necessary.  

You can find free hosting tiers [with most cloud providers](https://github.com/ripienaar/free-for-dev#major-cloud-providers).  
Be sure to get comfortable with cloud services, as these skills will definitely boost your scope of actions.  

If you're looking for more offensive deployments using Docker, be sure to check my other project: [**Redcloud**](https://github.com/khast3x/Redcloud).  
[**It contains more than 30 offensive templates to deploy, and a comfy UI to manage them!**](https://github.com/khast3x/Redcloud)

Finally, this is meant to help infosec students and professionals educate themselves and their peers on credential leaks.  

Thank you for reading through, I hope you enjoyed it.  
If thats the case, be sure to support the project by sharing this page!

----