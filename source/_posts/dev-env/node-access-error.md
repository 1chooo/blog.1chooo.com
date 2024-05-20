---
title: "如何解決 npm install 時報錯 - Error: EACCES: permission denied"
categories: DevEnv
date: 2024-05-15 00:00:00
tags: 
- Node
- npm
- permission
cover: /images/cover/dev-env/node-access-error/node-access-error.png
---

在我們安裝 npm 套件的時候，有時候會遇到 `EACCES: permission denied` 的錯誤，這是因為我們沒有權限寫入到指定的目錄，我們會看到以下錯誤（以安裝 aws-cdk 為例）：


```bash
$ npm install -g aws-cdk

npm ERR! code EACCES
npm ERR! syscall mkdir
npm ERR! path /usr/local/lib/node_modules/aws-cdk
npm ERR! errno -13
npm ERR! Error: EACCES: permission denied, mkdir '/usr/local/lib/node_modules/aws-cdk'
npm ERR!  [Error: EACCES: permission denied, mkdir '/usr/local/lib/node_modules/aws-cdk'] {
npm ERR!   errno: -13,
npm ERR!   code: 'EACCES',
npm ERR!   syscall: 'mkdir',
npm ERR!   path: '/usr/local/lib/node_modules/aws-cdk'
npm ERR! }
npm ERR!
npm ERR! The operation was rejected by your operating system.
npm ERR! It is likely you do not have the permissions to access this file as the current user
npm ERR!
npm ERR! If you believe this might be a permissions issue, please double-check the
npm ERR! permissions of the file and its containing directories, or try running
npm ERR! the command again as root/Administrator.

npm ERR! A complete log of this run can be found in: $USER/.npm/_logs/*.log
```

![EACCES: permission denied](/images/post/dev-env/node-access-error/01.png)

會發生的原因是因為我們沒有權限寫入到 `/usr/local/lib/node_modules` 目錄，這時候我們可以透過以下方式解決：

```bash
$ sudo chown -R $(whoami) /usr/local/lib/node_modules
```

![Add -R access](/images/post/dev-env/node-access-error/02.png)

我們在當前的 user 下，將 `/usr/local/lib/node_modules` 目錄的權限加上當前 user 的權限，這樣我們就可以在安裝 npm 套件的時候，不會遇到 `EACCES: permission denied` 的錯誤。

如此我們再重新輸入 `npm install` 的指令，就可以正常安裝套件了。

```bash
$ npm install -g aws-cdk

added 2 packages in 1s
```

![Install npm package again. It WORKED !!!](/images/post/dev-env/node-access-error/03.png)

如果我們不是要安裝 global 的套件，而是解決該專案當前的權限問題，我們可以透過以下方式解決：

```bash
$ sudo chown -R $(whoami) ~/.npm
```

會導致這個問題是因為我們在安裝時 root 與 user 之間的權限問題，透過這個方式，我們就可以解決這個問題，祝大家在安裝 npm 套件的時候都能順利不衝突！

### Reference

- [npm 在安装的时候提示 没有权限操作的解决办法 Error: EACCES: permission denied](https://segmentfault.com/a/1190000018660227)



