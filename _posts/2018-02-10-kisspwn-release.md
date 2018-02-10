---
layout: post
title: "Easy Python breach checker: kisspwn"
description: "Release of the kisspwn python module to query haveibeenpwned.com"
thumbnail: https://i.imgur.com/MoLtSU5.png
categories: python OSINT
excerpt_separator: <!--more-->
published: true
tags:
  - python
  - osint
  - haveibeenpwned

  ---
## Python kisspwn module release

--------
_This is a simple Python module to facilitate making queries to haveibeenpwned.com while respecting the API's throttling suggestions_

--------

The name is from the [KISS principle](https://en.wikipedia.org/wiki/KISS_principle).

All details can be found by clicking on the button below.  
<!--more-->  


> [![button](https://raw.githubusercontent.com/khast3x/khast3x.github.io/master/assets/demo/button_view-project-page.png)](https://khastex.club/kisspwn)

```python
# The module is pushed to pypi so you can just do:
$ pip3 install kisspwn
```


I used the [python cookiecutter tool](https://github.com/ionelmc/cookiecutter-pylibrary) to generate the boilerplate, I might make a post about it.

Here is a demo of a simple usage with the python interpreter, making a query with `test@example.com`.  


![demogif](https://i.imgur.com/7G8XUQ5.gif)
