---
layout: post
title: 'h8mail Release'
description: A quick overlook at finding passwords with h8mail
thumbnail: mug-hot
categories: h8mail
excerpt_separator: <!--more-->
published: false
tags:
  - h8mail
  - OSINT
  - password
  - breach
  - haveibeenpwned
  - leak
---

**h8mail v2 has just been released** :tada:

New features have been added to better hunt down passwords. The `README` file covers most of the expected information for running h8mail. I'll be showing off various use-cases that should beef up your searches.

<!--more-->

# Installing

h8mail is now distributed using `pip`, which is Python's package manager. This article won't go into details on how to configure python for your environment. To start you should at least:  

* Have Python3.6+ installed
* Be able to call python in your terminal

### Python
We'll review some common installation patterns below:  
Having Python 2 and 3 installed is common. You can check the default Python version by running:  

```bash
$ python --version
```

If it says `Python 2.x`, but you have installed Python 3.6+, chances are you can just run:

```bash
$ python3 --version
```

This is typically the case for OSX, Kali Linux, and older Linux distributions.
In the following instructions, remember to replace `python` with `python3` if that's your case.


### Using `pip` to download h8mail

Once your Python command sorted, you need to have `pip` installed. It probably shipped with your Python installation. To check, simply type:

```bash
$ pip -h
$ pip3 -h
```

If that's not the case, you can use an integrated Python module to install `pip` like so:

```bash
$ python -m ensurepip
```

This should take care of fetching, installing and linking `pip`. Depending on your configuration, 


# Local Searching

One of h8mail's freshest new feature is the local search. You can use compressed `.gz` files or uncompressed `.txt` files.  


Arguments can be passed loosely, such as:  

```bash
$ h8mail -t targets.txt -gz ./Leaks/2019-*
```
```bash
$ h8mail -t john@gmail.com -gz . ../Collection1/ ../Collection2/EU_* -lb /tmp/combolists/2019-* /tmp/dumps/leak.txt -o output.csv
```

If you wish to keep you search local, you can use `-sk` or `--skip` to skip online checks.


By default, h8mail will use multiprocessing, one "worker" for each file. This means h8mail will search multiple files at the same time. One "worker" will be spawned for each core your CPU has.

The local search can be combined with other h8mail features, such as HIBP, API services or regrouped results.


### *Loose* search

By default, h8mail looks for email patterns. This means you can pass raw html files as targets, h8mail will look for emails and automatically add them to targets.


```bash
$ h8mail -t admins-list.html -lb /tmp/combos.txt
```

Since h8mail supports globing, you could even do something like this:  
```bash
$ h8mail -t /crawled-html/*.html -gz ../Collection1/
```

Another one of h8mail's new features is the ability to perform *loose* searching, which is basically bypassing the pattern recognition. APIs don't support this, so be sure to skip online checks. This can be useful when looking for a domain, or patterns of usernames.

```bash
$ h8mail --loose --skip -t "evilcorp.com" -gz ../Collection1/
```

### Single file mode

To avoid loosing performance, data is not passed between processes while performing a local search. This also means that h8mail will not output a precise lookup progress bar.  
If you wish to disable multiprocessing to get a more verbose live lookup status, use the `-sf` or `--single-file` option, like so:  
```bash
$ h8mail -t targets.txt -lb /tmp/combolists/ -sf -sk
```


# pip

# Multi args

# Chasing

# Loose

# Leaklookup

# Docker