---
categories: h8mail
date: "2019-05-26T00:00:00Z"
description: "Or how to become a password necromancer with h8mail \U0001F480"
excerpt_separator: <!--more-->
image: /assets/h8mail/cover_writeup.png
published: true
tags:
- h8mail
- OSINT
- password
- breach
- haveibeenpwned
- leak
title: Getting started with h8mail v2
---

# 🌈 **h8mail v2 has just been released** 

New features have been added to better hunt down passwords.  

In the following write-up, we'll be covering h8mail's options with examples and use-cases. At the end of this page, you'll hopefully be bringing passwords back like a necromancer 💀

<!--more-->

![h8](https://i.postimg.cc/rw7mcgM1/cover-writeup.png)

# Table of Content
- **[Installing](#installing)**
  - **[Python](#python)**
  - **[Using `pip` to install h8mail](#using-pip-to-install-h8mail)**
    - **[Troubleshooting tips](#troubleshooting-tips)**
- **[Local Searching](#local-searching)**
    - **[Working with compressed or cleartext breaches](#working-with-compressed-or-cleartext-breaches)**
    - **[*Loose* search and inputs](#loose-search-and-inputs)**
    - **[Single file mode](#single-file-mode)**
    - **[Breach Compilation](#breach-compilation)**
- **[Chasing](#chasing)**
- **[Finding and downloading breaches](#finding-and-downloading-breaches)**
- **[Coming up next](#coming-up-next)**


h8mail's homepage can be found on [github](https://github.com/khast3x/h8mail).  
As with all good modern stories, we have to start with the software's installation procedure.  
If thats done already, **[you can jump to Local Searching](#local-searching)**.

----

# Installing

h8mail is now distributed using `pip`, which is a Python package manager. This article won't go into details on how to configure python for your environment. To start you should at least:  

* Have Python3.6+ installed
* Be able to call python in your terminal

## Python
Having both Python 2 and 3 installed is common. You can check the default Python version by running:  

```bash
$ python --version
```

If it says `Python 2.x`, and have installed Python 3.6+, chances are you can just run:

```bash
$ python3 --version
```

This is typically the case for OSX, Kali Linux, and older Linux distributions.
In the following instructions, remember to replace `python` with `python3` if that's your case.


## Using `pip` to install h8mail

To install h8mail using `pip`, simply use:
```bash
$ pip3 install h8mail
```

If you have not set your venvs, you might get a permission error saying `Consider using the --user option or check the permissions`.  
Simply add `--user` like so:
```bash
$ pip3 install --user h8mail
```

### Troubleshooting Tips
Here are some tips if you run into trouble.  
Once your `python` command is working, you need to have `pip` installed. It probably shipped with your Python installation.  
To check, simply type:

```bash
$ pip3 -h
```

If that's not the case, you can use an integrated Python module to install `pip` like so:

```bash
$ python -m ensurepip
$ pip3 -h
```

This should take care of fetching, installing and linking `pip`.  
If installation was successful and still having issues invoking `pip`, you can try running it as a module:  

```bash
$ python -m pip -h
```


![h8mail-install](https://i.postimg.cc/Vs9vznN3/h8mail-install.gif)


----

# Local Searching

One of h8mail's new feature is the local search. You can use compressed `.gz` files or uncompressed `.txt` files.  


### Working with compressed or cleartext breaches

Arguments can be passed loosely, such as:  

```bash
$ h8mail -t targets.txt -gz ./Leaks/2019-*
```

More complex:
```bash
$ h8mail -t john@gmail.com -gz . ../Collection1/ ../Collection2/EU_* -lb /tmp/combolists/2019-* /tmp/dumps/leak.txt -o output.csv
```

If you wish to keep you search local, you can use `-sk` or `--skip` to skip online checks.


By default, h8mail will use multiprocessing, one "worker" for each file. This means h8mail will search multiple files at the same time. One "worker" will be spawned for each core your CPU has.

The local search can be combined with other h8mail features, such as HIBP, API services or regrouped results.

*Illustrated local cleartext search:*
![txt](https://i.postimg.cc/L4Q7Y0hf/h8mail-local-cleartext.gif)


*Illustrated local compressed search with Collection1:*
![gz](https://i.imgur.com/o85iGND.gif)



### *Loose* search and inputs


Another one of h8mail's new feature is the ability to perform *loose* searching, which is basically bypassing the email pattern recognition.  
By default, h8mail looks for email patterns. This means you can pass raw files as targets, h8mail will look for emails and automatically add them to targets.


```bash
$ h8mail -t admins-list-page.html -lb /tmp/combos.txt
```

Since h8mail supports globing, you could even do something like this:  
```bash
$ h8mail -t /crawled-html/*.html -gz ../Collection1/
```
Next, we're going to introduce the `--loose` argument. APIs don't support this, so be sure to skip online checks with `-sk` or `--skip`. This can be useful when looking for a domain, or patterns of usernames inside local files.

```bash
$ h8mail --loose --skip -t "evilcorp.com" -gz ../Collection1/
$ h8mail --loose --skip -t "john.smith" "jsmith" -gz ../Collection1/
```

Or even recurring password:  
```bash
$ h8mail --loose --skip -t "JSm1th99" -gz ../Collection1/
```

*Illustrated `loose` search:*
![loose](https://i.postimg.cc/HspwmpT9/ezgif-3-eda2bfcfa2c3.gif)


### Single file mode

To avoid loosing performance, data is not passed between processes while performing a local search. This also means that h8mail will not output a precise lookup progress bar.  
If you wish to disable multiprocessing to get a more verbose live lookup status, use the `-sf` or `--single-file` option, like so:  
```bash
$ h8mail -t targets.txt -lb /tmp/combolists/ -sf -sk
```

### Breach Compilation

This feature was already part of h8mail's first version, and has been reintegrated. h8mail uses the `query.sh` script that is included in the torrent, meaning this will **only work on Linux & OSX** platforms. Windows users can still use the generic `-lb` on the data.

h8mail was built using the Breach Compilation version referenced [here](https://gist.github.com/scottlinux/9a3b11257ac575e4f71de811322ce6b3#gistcomment-2298792)

To use this option, simply point the `-bc` argument to the downloaded BreachCompilation folder.

```bash
$ h8mail -t test@evilcorp.com -bc ./BreachedCompilation/ -sk
```

----

# Chasing

Another one of h8mail's new feature is the ability to target related emails using hunter.io. This is referred as *chasing*.  
You can use the chasing feature with a [free hunter.io API key](https://hunter.io/api).

```bash
$ h8mail -t admin@evilcorp.com -ch 10 -c config.ini
```

The `-ch` or `--chase` option needs the number of email per target to *chase*, as well as the API key for hunter.io.

You can chain usage of the *chasing* feature with APIs and local search, making it a very powerful feature when targeting an organization.  

I might add search depths in a future version (launch a new *chase* with found related emails).

----

# Finding and downloading breaches

Without giving away all the keys, I'll add a few tips for those getting started.  
First, data breaches are **big**. You'll quickly want to learn how to use seedboxes and work remotely. Docker is great for this too.  

In regards to where to find them, you can get the BreachCompilation torrent referenced earlier. You can also look into specialized communities, such as raidforums, [link-base.org](https://link-base.org), or direct download them from [databases.today](https://databases.today/).  
This should be plenty enough to get you started.

----

# Coming up next

In the next write-ups, we're going to look at using h8mail with API services, such as [Snusbase](https://snusbase.com/) and [Leak-lookup](https://leak-lookup.com/).

We'll also look at some additional features, such as `--hide` for demonstrations, combining h8mail with Docker to download torrents super fast, even maybe using [WhatBreach](https://github.com/Ekultek/WhatBreach) with h8mail.



[![button-follow-me-on-twitter-to-stay-updated.png](https://i.postimg.cc/c1vyQ33j/button-follow-me-on-twitter-to-stay-updated.png)](https://twitter.com/kh4st3x)

----


I think I'll close the write-up here.  

If you create content based on h8mail (blog, video..) feel free to let me know, I'll add it to the homepage if its relevant.



Finally, be nice, use your powers to help others. And show support for your open-source developers :)   
Thank you for reading!


[![logo-transparent.png](https://i.postimg.cc/qqszqKBm/logo.png)](https://github.com/khast3x/h8mail)