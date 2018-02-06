---
layout: post
title: "Hardening Android : DNS"
thumbnail: android
categories: android
published: true
tags:
  - android
  - DNS
  - defense
  - malware
---

## Hardening Android with DNS66 & Quad9

-----

*I'll be illustrating a simple and very effective way to harden your Android phone **without** needing root. Demo below.*  

-----
We're going to locally filter all *Domain Name* queries through a selection of blacklists with [DNS66](https://f-droid.org/en/packages/org.jak_linux.dns66/) which can be installed from the [F-Droid Store](https://f-droid.org/en/), and finally set the [Quad9](https://www.globalcyberalliance.org/initiatives/quad9.html) DNS servers as default instead of the one provided by your ISP.  
This will be done transparently with a local VPN, and will apply to all outbound connections (so even applications that run in the background).  

For those not familiar with Quad9, here's a quick recap:  

Quad9 (**9.9.9.9**) works like any other public DNS server, except that it will **block** sites that are identified via threat feeds aggregated daily.   ([source](https://arstechnica.com/information-technology/2017/11/new-quad9-dns-service-blocks-malicious-domains-for-everyone/))

### Demo

*You'll find below two examples where the DNS hardening can be seen actively protecting the endpoint.*  

> Pastebin Android app

Pastebin Android application, that comes riddled with in-line advertisement. Bam 🔥 ![pastebin](https://github.com/khast3x/khast3x.github.io/blob/master/assets/demo/pastebin_all.jpg?raw=true)

> The Pirate Bay website

[The Pirate bay](thepiratebay.org) unblocked from ISP, while also blocking your typical pirate page adverts with redirects and drive-by downloads. Neat 🔥 🔥 ![tpb](https://github.com/khast3x/khast3x.github.io/blob/master/assets/demo/tpb_all.jpg?raw=true)



### Installing the F-Droid Store & DNS66

*This will require allowing third-party apps (non Google Play applications)*

>  The DNS66 app [presentation page](https://f-droid.org/en/packages/org.jak_linux.dns66/) contains all required links, if want to take the shortcuts.  🚀

1. Steps for the F-Droid Store
    1. Allow `Unknown sources` from device settings  
      	1. Go to Settings > Security > "Device Administration" section  
      	2. Swipe to `Allow` on `Unknown sources` settings
    1. Install F-Droid    
      	1. [Click here](https://f-droid.org/FDroid.apk) to download the APK  
      	2. Install the APK by opening the file  
      	3. Open the F-Droid store  
      	4. *Give it a minute so it refreshes the repositories* ⏳  
1. Install [DNS66](https://f-droid.org/en/packages/org.jak_linux.dns66/)  
	1. Wait for F-Droid to update  
	1. Search for `DNS66` or go to the [DNS66](https://f-droid.org/en/packages/org.jak_linux.dns66/) app presentation page and install  

### Harden device with DNS66 & Quad9

Once inside the DNS66 application, *hit the refresh button* ⏳.  

This will update all blacklists that come out of the box, mixing advertisement and malicious hosts blacklists.  

Now switch to the "DNS" tab and add Quad9 ```9.9.9.9``` as your desired DNS server using the "+" button.
Save, disable application defaults, enable Quad9.  

*The picture below shows the configuration edit page, and what it should look like once activated.*
![quad9](https://github.com/khast3x/khast3x.github.io/blob/master/assets/demo/quad9_all.jpg?raw=true)  


>You're done! 👏

-----
### Notes

* You can choose to *Resume on system start-up*. Since it does not create a remote connection (the VPN is local), the battery consumption is minimal. I'd recommend it.
* Same with *Watch connection*, has made it even more transparent in my usage.
* *IPV6 Support* depends on your configuration. Turn it off if your phone seems to be disconnected.
* Sometimes, when switching between Wifi and Data, the connection can seem slower or even hanging. If thats the case, simply taping the DNS66 infobar so it can refresh solves the issue.

-----
### Technical details
*for those who want to read a bit more about what's happening*

Android phones are easy targets for anyone with a little Google-Fu. The [number](https://github.com/AaronVigal/Metasploit-Android) [of](https://github.com/giovannicolonna/msfvenom-backdoor-android) [tools](https://github.com/AhMyth/AhMyth-Android-RAT) [to](https://github.com/Screetsec/TheFatRat) [generate](https://github.com/DoctorsHacking/Argus-RAT) Android payloads on github alone is getting ridiculous (btw, each word is a link to a *different* tool).

This is security by applying a DNS in-depth defense mechanism. It will block requests made from your phone to advertisement servers, but also the most recent malware campaign indicators provided by some big players, as well as multiple research communities.  
This works for vanilla Android too, as it does not require root permissions to use a VPN.  

A malicious campaign can easily hide its code in legitimate APKs, and go undetected by Android anti-virus apps for months before getting caught. The infection might be dodging the phone's local protection software, but the malware has to *call home* at some point (make requests to the Command & Control Server), and thats where we'll block it.  

> If the malware can't call home, it can't ex-filtrate data or receive new instructions.  

(well, *if there's a will there's a way* but egress just got a whole lot harder) And at some point the AV will have signatures for it.  

We're using a mix of several blacklists that come from know researcher feeds, and Quad9 indicators.  


 [`DNS66`](https://f-droid.org/en/packages/org.jak_linux.dns66/)  will create a local VPN connection, thus forcing all outbound DNS requests through your desired servers.  
When active, any form of Internet connection is tunneled by the underlying network stack. This is often used to access websites that are normally blocked by ISPs.  
This is a rather nice side effect!
To be honest its quite a clever trick to enforce new DNS options WITHOUT having to root your phone.  

Once [`DNS66`](https://f-droid.org/en/packages/org.jak_linux.dns66/) is installed, we'll set it to query the Quad9 DNS servers at 9.9.9.9.


> Quad9 Technical workflow ![q9illustration](https://www.globalcyberalliance.org/wp-content/uploads/quad9-graphic.png)  


Your phone will now always check a local, constantly updated blacklist, before querying a collaborative security DNS server that also blocks adverts and circumvents censorship. Yey 😎
