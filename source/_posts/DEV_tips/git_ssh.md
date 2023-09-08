---
title: 踏入 Git 的世界：使用 ssh 與 GitHub 連線 👨🏻‍💻
categories: DEV
date: 2023-09-08 00:00:00
tags: 
- Git 
- GitHub
- SSH Key
cover: https://1chooo.github.io/1chooo-blog/images/cover/git_tips_cover.png
---

**本文綱要**
- [前言](#前言)
- [1. 產生 ssh key](#1-產生-ssh-key)
- [2. 取得 public ssh key](#2-取得-public-ssh-key)
- [3. 把 public key 設定到 GitHub](#3-把-public-key-設定到-github)
  - [A. 前往 GitHub 設定](#a-前往-github-設定)
  - [B. 點擊 "SSH and GPG keys"](#b-點擊-ssh-and-gpg-keys)
  - [C. 進入 "SSH and GPG keys" 頁面後點擊 "New SSH key"](#c-進入-ssh-and-gpg-keys-頁面後點擊-new-ssh-key)
  - [D. 貼上 public key 最後送出](#d-貼上-public-key-最後送出)
- [How to reach out to me](#how-to-reach-out-to-me)

### 前言
Git 是每位軟體工程師日常工作不可或缺的工具之一，畢竟軟體開發常常需要跟他人合作，甚至是維護、更新等⋯⋯可能都需要參照過去的成果，甚至需要快速與團隊同步，因此 Git 對大家而言都不陌生吧！
但是，有時候我們會遇到一些問題，例如：每次 push 都需要輸入帳號密碼，或是每次 push 都需要輸入密碼，這些都是可以透過 ssh 來解決的，接下來就讓我們一起來看看如何使用 ssh 與 GitHub 連線吧！

### 1. 產生 ssh key
首先，我們需要先產生 ssh key，這個 key 會被存在 `~/.ssh` 資料夾中，如果沒有的話，可以使用以下指令建立（記得要把 email 改成你自己的 email，否則永遠不會成功哦！）：

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

上述操作 `ed25519` 其實是較新的演算法，如果電腦不支援的話也可以使用以下另一種演算法生成（同樣也要記得把 email 改成你自己的 email）：
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

以下將使用 `id_rsa` 做示範，接下來將出現以下畫面，直接按 **Enter** 就會幫你把產生的 key 放在預設的地方 `~/.ssh/id_rsa` ，也就是下方括號內的位址。
```bash
$ Enter a file in which to save the key (/Users/you/.ssh/id_rsa):
```

接下來會出現以下畫面，若不想以後 push 都要輸入 `passphrase` 的話，就連續點擊兩次 **Enter** 這樣 `passphrase` 就會是空的，以後 push 就不用輸入了！

```bash
# Click Enter Twice
$ Enter passphrase (empty for no passphrase): [Type a passphrase]
$ Enter same passphrase again: [Type passphrase again]
```

這樣做 ssh key 就已經生成好了！

總共會生成兩個 key，private and public key，接下來會帶大家如何找到這兩個 key。

### 2. 取得 public ssh key

接著我們要進到剛剛放置 key 的位置，因此我們照著以下流程，把 public 的 key 拿出（副檔名為 `.pub`），要特別注意 GitHub 只需要 public 的 key，private 要自己留好！千萬不要給任何人！
```bash
$ cd .ssh
$ ls
id_rsa          id_rsa.pub

$ cat id_rsa.pub
```

接下來就把 `cat id_rsa.pub` 的內容複製下來，我們就可以回 GitHub 做最後一步設定了！

### 3. 把 public key 設定到 GitHub

接下來我們要把 public key 設定到 GitHub，這樣 GitHub 才能辨識你的電腦，讓你可以透過 ssh 連線到 GitHub，這樣就可以真的達到不用每次 push 都要輸入帳號密碼了！接下來將用截圖畫面的方式展示步驟！

#### A. 前往 GitHub 設定

![](https://1chooo.github.io/1chooo-blog/images/post/DEV/git_ssh/01.png)

#### B. 點擊 "SSH and GPG keys"
![](https://1chooo.github.io/1chooo-blog/images/post/DEV/git_ssh/02.png)

#### C. 進入 "SSH and GPG keys" 頁面後點擊 "New SSH key"
![](https://1chooo.github.io/1chooo-blog/images/post/DEV/git_ssh/03.png)

#### D. 貼上 public key 最後送出
![](https://1chooo.github.io/1chooo-blog/images/post/DEV/git_ssh/04.png)

照著上述步驟就一切沒問題了，以後把專案 clone 到本地就選擇 ssh 的方式就搞定啦！ 
![](https://1chooo.github.io/1chooo-blog/images/post/DEV/git_ssh/05.png)

如果原先專案是走 `http` 的方式 `clone` 下來的話只要做以下更改就可以換成 `ssh` 啦！

```bash
$ git remote set-url origin <your_project_ssh_url>
```

如此以後專案 push 到 GitHub 就都會走 ssh 了也不需要每次都輸入帳號密碼了！最後祝大家以後都開發順利！可以開始進行更多遠端的 Git 操作了！

### How to reach out to me
- Ins: [@lcho____](https://www.instagram.com/lcho____/)
- Linkedin: [Hugo ChunHo Lin](https://www.linkedin.com/in/1chooo/)
- GitHub: [1chooo](https://github.com/1chooo)
- My Linktree: [1chooo's Linktree](https://1chooo.github.io/linktree/)
- Email: hugo970217@gmail.com