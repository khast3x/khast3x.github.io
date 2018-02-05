---
layout: post
title: Hardening vanilla Android with Quad9 DNS
thumbnail: android
categories: android
published: true
tags:
  - android
  - DNS
  - defense
toc: true
---

## Vanilla Android hardening: DNS66 and Quad9

<small>
### Abstract
Android phones are easy targets for anyone with a little Google-Fu. The [number](https://github.com/AaronVigal/Metasploit-Android) [of](https://github.com/giovannicolonna/msfvenom-backdoor-android) [tools](https://github.com/AhMyth/AhMyth-Android-RAT) [to](https://github.com/Screetsec/TheFatRat) [generate](https://github.com/DoctorsHacking/Argus-RAT) Android payloads, on github alone is getting ridiculous.

I'll be explaining a simple and very effective way to harden your Android phone without root.  

We're going to redirect all DNS queries through a selection of blacklists, and finally query the Quad9 DNS servers.  
For those not familiar with Quad9, here's a quick recap:
> Called Quad9 (after the **9.9.9.9** Internet Protocol address the service has obtained), the service works like any other public DNS server (such as Google's), except that it won't return name resolutions for sites that are identified via threat feeds the service aggregates daily.  ([source](https://arstechnica.com/information-technology/2017/11/new-quad9-dns-service-blocks-malicious-domains-for-everyone/))

### Demo


<div class="datatable-begin"></div>

| Test  |  Before     |  After
------- | -------------------------------------
Pastebin app with tons of adverts | <img src="https://raw.githubusercontent.com/khast3x/khast3x.github.io/master/assets/demo/pastebin_no_vpn.jpg" width="170" height="270" />  | <img src="https://raw.githubusercontent.com/khast3x/khast3x.github.io/master/assets/demo/pastebin_vpn.jpg" width="170" height="270" />          
thepiratebay.org + typical screen hijacking adverts | <img src="https://raw.githubusercontent.com/khast3x/khast3x.github.io/master/assets/demo/tpb_no_vpn.jpg" width="170" height="270" /> | <img src="https://raw.githubusercontent.com/khast3x/khast3x.github.io/master/assets/demo/tpb_vpn.jpg" width="170" height="270" />  


<div class="datatable-end"></div>



### Installing F-Droid & DNS66

Install the F-Droid store, and then fetch `DNS66`

##### F-Droid

*This will require allowing third-party apps (non Google Play applications), which can also be considered as a threat.*


1. Allow `Unknown sources`
	1. Go to Settings > Security > "Device Administration" section
	1. Swipe to `Allow`

1. Install F-Droid
	1. [Click here](https://f-droid.org/FDroid.apk) to download the APK
	1. Install the APK by opening the file
	1. Open the F-Droid store
	1. **Give it a minute so it refreshes the repositories**

##### DNS66

1. Install DNS66
	1. Wait for F-Droid to update
	1. Search for `DNS66` and install

##### Quad9

Once inside the application, *hit the refresh button*.  
This will update all blacklists that come out of the box, mixing advertisement and malicious hosts.  
Switch to the "DNS" tab and add {picture of editing quad9} quad9 ```9.9.9.9``` as your desired DNS server.  
Save and select it.

#### You're done!


### Details

This is security by applying a DNS in-depth defense mechanism. It will block requests made from your phone to advertisement servers, but also the most recent malware campaign indicators provided by some big players as well as multiple research communities.  
This works for vanilla Android too, as it does not require root permissions.  

A malicious campaign can easily hide its code in legitimate APKs, and go undetected by Android anti-virus apps for months before getting caught. The infection might be dodging the AV, but the malware has to *call home* at some point (make requests to the Command & Control Server), and thats where we'll block it.  

> If the malware can't call home, it can't ex-filtrate data or receive new instructions.  

(well, *if there's a will there's a way* be egress just got a whole lot harder)  
And at some point the AV will have signatures for it.  

We're using a mix of several blacklists that come from know researcher feeds, and Quad9 indicators.  


 `DNS66`  will create a local VPN connection, thus forcing all outbound DNS requests through your desired servers.  
When active, any form of Internet connection is tunneled by the underlying network stack. This trick is often used to access websites that are typically blocked by ISPs and also block adverts.  
This is a rather nice side effect!
To be honest its quite a clever trick to enforce new DNS options WITHOUT having to root your phone.  

Once `DNS66` is installed, we'll set it to query the Quad9 DNS servers at 9.9.9.9.


</small>
