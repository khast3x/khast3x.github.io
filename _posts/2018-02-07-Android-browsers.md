---
published: false
---
## Hardening Android with privacy focused browsers

-----
*This is a quick post about my experience with browsers on Android. I'll be running down how I've configured my phone for daily usage.*

-----

I consider two major use-cases when it comes to opening links on my phone.  


1. **Opening links from various apps without much prior knowledge of content.**  
This will call the default browser without prompting the user if Chrome is default.  
But I want this to be as [sandboxed](https://en.wikipedia.org/wiki/Sandbox_(computer_security)) as possible. I don't want scripts to read my cookies, so no pre-loaded cookies. No pre-loaded tabs either. Ideally, the browser called upon in this use-case must disposable.  
_When clicking on links, some applications (such as Instant Messaging) will sometimes use the Chrome browser as an in-line browser if no others are set. So it's basically opening the Chrome browser inside an application. The browser with all the other tabs and logged in accounts. And saved passwords._

2. **Opening pages that require persistant data**. These include logged in accounts, pre-set forms, preferences, bookmarks, keeping tabs open. Basically, anything not a memesite/article/video/clickbait website, which is a big part of the content that can be shared.


Here is what I'm currently going for. It's very likely not the most optimised, but I find that its a very good compromise between **security and usability**.  


Keep in mind that I'm also running the "Hardened DNS" configuration I wrote about here. I've tried this setup against OPSEC javascript browser fingerprinting tools, and I have to say its not bad at all.

> Day to day browsing

I've downloaded Firefox Focus, and explicitly set it up as the default browser. You can read about the the specifics on the Play Store page, but it's basically the ideal solution to my sandboxed approach. I've gone a step further and blocked all types of trackers (ad, analytics, social, _other content_).  
There is a `Send usage data` option, but it's turned off by default if I recall correctly.


> When persistant data is required

For this I've tried several popular recommendations (hello /g/) and settled on using Brave browser. Its great for keeping browsing clean without maintainance, while easily blocking or modififying it's behavior according to your paranoia level.

-----

### Notes:

If there is a link that you want to open outside of the sandboxed Firefox app, just share it to the Brave Browser.

