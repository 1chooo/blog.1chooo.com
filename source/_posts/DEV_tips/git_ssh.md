---
title: 蛤！你的 GitHub 一直推不上去，快試試 ssh 吧！
categories: DEV
date: 2023-07-31 21:00:00
tags: 
- git 
- tips
cover: https://1chooo.github.io/1chooo-blog/images/cover/git_tips_cover.png
---

**本文綱要**
- [Generate `SSH key`](#generate-ssh-key)
- [How to reach out to me](#how-to-reach-out-to-me)

### Generate `SSH key`
```bash
# New Algorithm
$ ssh-keygen -t ed25519 -C "Gitlab SSH Key"

# Old Method
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

~/.ssh/id_ed25519

# Click Enter Twice
$ Enter a file in which to save the key (/Users/you/.ssh/id_ed25519):
$ Enter passphrase (empty for no passphrase): [Type a passphrase]
$ Enter same passphrase again: [Type passphrase again]

$ cd .ssh
$ cat id_rsa.pub
```

### How to reach out to me
- Ins: [@lcho____](https://www.instagram.com/lcho____/)
- Linkedin: [Hugo ChunHo Lin](https://www.linkedin.com/in/1chooo/)
- GitHub: [1chooo](https://github.com/1chooo)
- About me: [1chooo](https://sites.google.com/g.ncu.edu.tw/1chooo)
- Email: hugo970217@gmail.com