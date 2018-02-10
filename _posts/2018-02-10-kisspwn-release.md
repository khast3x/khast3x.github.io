---
layout: post
title: "'kisspwn' : Easy Python breach checker"
description: "summary_large_image"
summary: "Release of the kisspwn python module to query haveibeenpwned.com"
thumbnail: kisspwn
image:
  path: /assets/demo/boat-1299071.png
  height: 100
  width: 100
categories: python OSINT
excerpt_separator: <!--more-->
published: true
tags:
  - python
  - osint
  - haveibeenpwned
---


## Introducing my 'kisspwn' module
--------
_This is a simple Python module to facilitate making queries to haveibeenpwned.com while respecting the API's throttling suggestions_  

_The name is from the [KISS principle](https://en.wikipedia.org/wiki/KISS_principle)._


--------

All details can be found by clicking on the button below.  
<!--more-->  

You'll find all required details on how to install module from pip or from source, as well as code snippet.
## [![button](https://raw.githubusercontent.com/khast3x/khast3x.github.io/master/assets/demo/button_view-project-page.png)](https://khast3x.club/kisspwn/)

Quick installation:

```bash
# The module is pushed to pypi so you can just do:
$ pip3 install kisspwn
```


I used the [python cookiecutter tool](https://github.com/ionelmc/cookiecutter-pylibrary) to generate the boilerplate, I might make a post about it.

Here is a demo of a simple usage with the python interpreter, making a query with `test@example.com` as the target.  


![demogif](https://i.imgur.com/7G8XUQ5.gif)
