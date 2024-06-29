---
title: Three Methods to Find Your Public IP Address From Linux Command Line
categories: DevOps
date: 2024-03-21 00:00:00
tags: 
- Linux
- IP
- Command Line
cover: /images/cover/dev-ops/three-methods-to-find-your-public-ip-address-from-linux-cmd-line.png
---

When we want to connect a remote host through SSH today, sometimes we need to know our public IP address so that we can identify the IP address we are connecting from to the remote host. This article will teach you how to find your public IP address on a Linux system using commands.

### Method 1: Find Public IP address using curl Command

To retrieve your public IP address, you can use external web services like `ifconfig.me`, `ifconfig.io`, or `ipinfo.io`. These services provide your public IP address through a simple HTTP request. Here's how you can use the curl command to fetch your public IP:

1. Open your terminal application. You can do this by searching for "Terminal" in the application launcher or by pressing "Ctrl + Alt + T "(depending on your Linux distribution).

2. Type the following command and hit Enter:

```bash
$ curl ifconfig.me
YOUR_PUBLIC_IP_ADDRESS
```

```bash
$ curl ifconfig.io
YOUR_PUBLIC_IP_ADDRESS
```

```bash
$ curl ipinfo.io.
{
  "ip": "YOUR_PUBLIC_IP_ADDRESS",
  "hostname": "YOUR_PUBLIC_IP_ADDRESS",
  "city": "YOUR_CITY",
  "region": "YOUR_REGION",
  "country": "YOUR_COUNTRY",
  "loc": "YOUR_LATITUDE,YOUR_LONGITUDE",
  "org": "YOUR_ISP",
  "postal": "YOUR_POSTAL_CODE",
  "timezone": "YOUR_TIMEZONE",
  "readme": "https://ipinfo.io/missingauth"
}
```

### Method 2: Download Public IP Address via wget and ipinfo.io
In this method, we will use the `wget` command to download our IP address information from the `ipinfo.io` service. Here are the steps:

1. Open your terminal application. You can do this by searching for "Terminal" in the application launcher or by pressing "Ctrl + Alt + T" (depending on your Linux distribution).
2. Type the following command and press Enter:

```bash
$ wget -qO - https://ipinfo.io/ip --timeout=20
YOUR_PUBLIC_IP_ADDRESS
```

```bash
$ PUBLIC_IP=$(wget http://ipinfo.io/ip -qO - --timeout=20)
$ echo $PUBLIC_IP
YOUR_PUBLIC_IP_ADDRESS
```

### Method 3: Get Public IP Address via dig Command

The dig command is another valuable tool for querying DNS-related information, including your public IP address. Here's how you can use dig to find your public IP address:

1. Open your terminal application. You can do this by searching for "Terminal" in the application launcher or by pressing "Ctrl + Alt + T" (depending on your Linux distribution).
2. Type the following command and hit Enter:

```bash
$ dig +short myip.opendns.com @resolver1.opendns.com
YOUR_PUBLIC_IP_ADDRESS
```

### Conclusion

Finding your public IP address in Linux using the command line is an important skill for Linux users. Whether you’re a system administrator, developer, or everyday user, these methods will help you quickly retrieve your public IP address. This information is valuable for troubleshooting network issues and securing your connections. Remember these command-line techniques for swift access to your public IP address!

Hope You Guys connect to the remote host successfully. If you have any questions, feel free to ask in the comments below.
