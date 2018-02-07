---
layout: post
title: "Hardening Android : Browsers"
thumbnail: android
categories: android tips
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
*This is a quick post about my experience with browsers on Android. I'll be showing off how I've configured my phone for daily usage. You'll actually be gaining performance too!*

-----

I consider two major use-cases when it comes to opening links on my phone.  


1. **Opening links from various apps without much prior knowledge of content.**  
I want this to be as [sandboxed](https://en.wikipedia.org/wiki/Sandbox_(computer_security)) as possible.  
To be explicit: I don't want scripts to be able to read my cookies, so no pre-loaded cookies.  
No pre-loaded tabs either.  
Ideally, the browser called upon in this use-case must be disposable once content is seen. It is removed from memory completely ♻️  

2. **Opening pages that require persistent data.**  
These include logged in accounts, pre-set forms, preferences, bookmarks, keeping tabs open. Basically, anything not a memesite/article/video/clickbait website, which is a big part of the content that y'all browse.


Here is what I'm currently going for. It's likely not the meanest configuration, but I find that its a very good compromise between **security and usability**.  

-----
🔴  Keep in mind that I'm also running the "Hardened DNS" configuration [I wrote about earlier](https://khast3x.club/android/tips/2018/02/05/Android-Quad9/).  
I've tried this setup against [OPSEC](https://en.wikipedia.org/wiki/Operations_security) JavaScript & DNS  fingerprinting tools, and I have to say its not bad at all 😎 .

-----

> Day to day browsing

I've downloaded [Firefox Focus](https://play.google.com/store/apps/details?id=org.mozilla.focus), and explicitly set it up as the **default browser**.  
You can read about the the specifics on the Play Store page, but it's basically the ideal solution to my sandboxed approach.   
💡  If there is a link that you want to open outside of the sandboxed Firefox app, just _share_ it to your persistent browser.  
When closing Firefox, instead of leaving another open tab in the background when pressing back, it will remove all traces of the opened page from memory.  
Neat 🔥


I've gone a step further and blocked all types of trackers (ad, analytics, social, _other content_). YMMV  
There is a _Send usage data_ option, but it's turned off by default if I recall correctly.  

[![fffocus](https://github.com/khast3x/khast3x.github.io/blob/master/assets/demo/fffocus.png?raw=true)](https://play.google.com/store/apps/details?id=org.mozilla.focus)

> When persistent data is required. Accounts, tabs etc...

For this I've tried several popular recommendations (hello /g/) and settled on using [Brave browser](https://play.google.com/store/apps/details?id=com.brave.browser).  
Its great for keeping browsing clean without maintenance, while easily blocking or modifying it's behavior according to your paranoia level. Some basics settings are worth changing like the default search engine (I recommend [Startpage](https://www.startpage.com/)).  
Tip: you'll have to uncheck _Send metrics_ in the Privacy options.

[![bravebrowser](https://github.com/khast3x/khast3x.github.io/blob/master/assets/demo/brave.png?raw=true)](https://play.google.com/store/apps/details?id=com.brave.browser)

-----

### Privacy settings comparison

I though it would be interesting to include this for the reader's pleasure.
![browsers_privacy_settings](https://github.com/khast3x/khast3x.github.io/blob/master/assets/demo/browsers_privacy_settings.jpg?raw=true)

Overall, not keeping the daily *junk* accumulated through the days in the form of tabs will have a nice impact on the overall device usage.  

> Enjoy 👍

-----

Additional considerations on defaults:  
_When clicking on links, some applications (such as Instant Messaging apps) will sometimes use the Chrome browser as an in-line browser if no others are set as  default.  
So it's basically opening the Chrome browser inside an application. The browser with all the other tabs and logged in accounts. And saved passwords. We don't want that unless explicitly... wanted_

[Brave browser picture: By Source (WP:NFCC#4), Fair use](https://en.wikipedia.org/w/index.php?curid=54004571)
