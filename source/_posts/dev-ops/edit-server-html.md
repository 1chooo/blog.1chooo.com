---
title: 如何編輯 /var/www/html 中的檔案
categories: DEV
date: 2024-03-18 00:00:00
tags: 
- Linux
cover: /images/cover/git_tips_cover.png
---

首先為甚麼我們會需要編輯 `/var/www/html` 中的檔案呢？這是因為我們如果要在 Linux 中架設屬於我們的伺服器，像是 Apache 或是 Nginx，我們需要將我們的網頁檔案放在 `/var/www/html` 中。因此，如果我們要修改我們的網頁檔案，我們就需要進入這個資料夾中進行修改。

但是在 Linux 中的 `/` 之下的檔案都是屬於 root 的，因此我們需要使用 `sudo` 來進行修改。因此之前在要編輯 `/var/www/html` 中的檔案時候，看到很多人的做法是直接修改權限，因為 Linux 每個檔案都可以設定不同的權限，但其實如果 user 本身權限不同，會導致一些問題。

因此我想提供一個當直接擁有 root user 權限時，最快能成功修改的方法，那就是直接加上 sudo 來進行修改即可！

```bash
$ sudo vi /var/www/html/index.php
```

這樣就可以更改 `/var/www/html` 中的檔案了！