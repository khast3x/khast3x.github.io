---
layout: post
title: "Hardening Android : Browsers"
thumbnail: android
categories: android, tips
published: true
tags:
  - android
  - OPSEC
  - privacy
  - applications
  - malware
  - Firefox
  - Brave
---
## Hardening Android with Privacy-Focused Browsers

-----
*This is a quick post about my experience with browsers on Android. I'll be running down how I've configured my phone for daily usage.*

-----

I consider two major use-cases when it comes to opening links on my phone.  


1. **Opening links from various apps without much prior knowledge of content.**  
I want this to be as [sandboxed](https://en.wikipedia.org/wiki/Sandbox_(computer_security)) as possible.  
To be explicit: I don't want scripts to be bale to read my cookies, so no pre-loaded cookies. No pre-loaded tabs either. Ideally, the browser called upon in this use-case must be disposable once content is seen. ♻️  

2. **Opening pages that require persistant data.**  
These include logged in accounts, pre-set forms, preferences, bookmarks, keeping tabs open. Basically, anything not a memesite/article/video/clickbait website, which is a big part of the content that y'all browse.

Security considerations: _When clicking on links, some applications (such as Instant Messaging apps) will sometimes use the Chrome browser as an in-line browser if no others are set as  default. So it's basically opening the Chrome browser inside an application. The browser with all the other tabs and logged in accounts. And saved passwords. We don't want that unless explicitly... wanted_

Here is what I'm currently going for. It's very likely not the most optimized, but I find that its a very good compromise between **security and usability**.  


🔴 Keep in mind that I'm also running the "Hardened DNS" configuration [I wrote about earlier](https://khast3x.club/android/2018/02/05/Android-Quad9/). I've tried this setup against [OPSEC](https://en.wikipedia.org/wiki/Operations_security) JavaScript browser fingerprinting tools, and I have to say its not bad at all.

-----

> [![fffocus](https://github.com/khast3x/khast3x.github.io/blob/master/assets/demo/fffocus.png?raw=true)](https://play.google.com/store/apps/details?id=org.mozilla.focus)Day to day browsing

I've downloaded [Firefox Focus](https://play.google.com/store/apps/details?id=org.mozilla.focus), and explicitly set it up as the default browser.  
You can read about the the specifics on the Play Store page, but it's basically the ideal solution to my sandboxed approach.   I've gone a step further and blocked all types of trackers (ad, analytics, social, _other content_).  
There is a `Send usage data` option, but it's turned off by default if I recall correctly.


> [![bravebrowser](https://github.com/khast3x/khast3x.github.io/blob/master/assets/demo/brave.png?raw=true)](https://play.google.com/store/apps/details?id=com.brave.browser)When persistent data is required

For this I've tried several popular recommendations (hello /g/) and settled on using [Brave browser](https://play.google.com/store/apps/details?id=com.brave.browser&hl=en).  
Its great for keeping browsing clean without maintenance, while easily blocking or modifying it's behavior according to your paranoia level. Some basics settings are worth changing like the default search engine (I highly recommend [Startpage](https://www.startpage.com/))

-----

### Notes:

If there is a link that you want to open outside of the sandboxed Firefox app, just share it to the Brave Browser.  
Other than that, when closing Firefox, instead of leaving another open tab in the background when pressing back, it will remove all traces of the opened page from memory.  

> Neat 🔥

-----

Brave browser picture: By Source (WP:NFCC#4), Fair use, https://en.wikipedia.org/w/index.php?curid=54004571