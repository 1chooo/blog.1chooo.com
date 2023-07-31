---
title: 《Git 軟體開發新手村！》
categories: DEV
date: 2023-07-30 15:00:00
tags: 
- git 
- tips
cover: https://1chooo.github.io/1chooo-blog/images/cover/git_tips_cover.png
---

> 上課沒教過 Git 啊⋯⋯考試是要怎麼提交到 GitHub 😖😖😖

當我們學習程式語言的語法時，通常會從 Hello World 開始，逐步熟悉各種語言特性，無論是現在熱門的 `Python`、`Java`、`C++` 等等。我們會掌握各種型別、流程控制以及迴圈的使用，並學會打包程式碼成可重複使用的函式 (`def`) 甚至區份類別的物件導向式程式設計。然而，令人遺憾的是，在許多教學中，很少涵蓋軟體開發過程中最重要的**版本控制**。無論是多人協作還是個人的大型專案開發，版本控制都是開發者的好朋友。畢竟，使用 `control/command + z`` 總會遇到無法回復的情況。

因此正是上面所述的原因，今天 Ho 將在文章中帶大家入門一些軟體開發過程中常會用到的 Git 指令。希望能幫助大家更輕鬆地掌握 Git 這強大開發助手的使用。

**本文綱要**
- [Generate `SSH key`, `git --config`](#generate-ssh-key-git---config)
- [Make the commit](#make-the-commit)
  - [Someone has been through the bad experience](#someone-has-been-through-the-bad-experience)
  - [Solving method](#solving-method)
- [Check Git Status](#check-git-status)
- [Fork Remote Repo](#fork-remote-repo)
- [Fetch and Merge](#fetch-and-merge)
  - [If you don't want to merge in your local change](#if-you-dont-want-to-merge-in-your-local-change)
  - [With `pull`](#with-pull)
- [Rebase](#rebase)
- [Stash](#stash)
- [Pop](#pop)
- [Gitignore](#gitignore)
- [Reference](#reference)
- [How to reach out to me](#how-to-reach-out-to-me)

### Generate `SSH key`, `git --config`

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

ssh -T git@gitlab.com
$ git config --global user.name "your_username"
$ git config --global user.email "your_email_address@example.com"

$ git config --list
```

### Make the commit

```bash
$ git add the_changed_file
$ git commit -m "the comment of the change"
$ git branch -M branch_name
$ git push -u origin branch_name    # git push REMOTE-NAME BRANCH-NAME

$ git push REMOTE-NAME TAG-NAME
$ git push REMOTE-NAME --tags
```
#### Someone has been through the bad experience
```bash
$ git push REMOTE-NAME LOCAL-BRANCH-NAME:REMOTE-BRANCH-NAME    # git push <remote> <source branch>:<dest branch> 
```
#### Solving method

Branch2 is deleted and branch1 has been updated with some new changes.

Hence, if you want only the changes push on the branch2 from the branch1, try procedures below:

- On branch1: `git add .`
- On branch1: `git commit -m 'comments'`
- On branch1: `git push origin branch1`
- On branch2: `git pull origin branch1`
- On branch1: revert to the previous commit.

### Check Git Status


```bash
$ git status
$ git log
$ git checkout
```

### Fork Remote Repo

You might already know that you can **"fork"** repositories on GitHub.

```bash
$ git remote add upstream THEIR_REMOTE_URL

git fetch upstream
# Grab the upstream remote's branches
> remote: Counting objects: 75, done.
> remote: Compressing objects: 100% (53/53), done.
> remote: Total 62 (delta 27), reused 44 (delta 9)
> Unpacking objects: 100% (62/62), done.
> From https://github.com/OCTOCAT/REPO
>  * [new branch]      main     -> upstream/main
```

### Fetch and Merge

#### If you don't want to merge in your local change
```bash
$ git fetch REMOTE-NAME
$ git merge REMOTE-NAME/BRANCH-NAME
```

#### With `pull`
```bash
$ git pull REMOTE-NAME BRANCH-NAME
```

### Rebase

```bash
$ git rebase --interactive OTHER-BRANCH-NAME

$ git rebase --interactive HEAD~7
pick 1fc6c95 Patch A
pick 6b2481b Patch B
pick dd1475d something I want to split
pick c619268 A fix for Patch B
pick fa39187 something to add to patch A
pick 4ca2acc i cant typ goods
pick 7b36971 something to move before patch B
```

### Stash

When we forget to pull the remote source first, we can stash our commit then pull the remote commit first.

```bash
$ git stash -u

$ git stash list    # All stash
$ git stash show    # The latest stash
$ git stash show -u
```

### Pop

Pop out the content in the stash
```bash
$ git stash pop
```

### Gitignore

```bash
$ echo debug.log >> .gitignore
  
$ git rm --cached debug.log
```

```bash
$ cat .gitignore
*.log
  
$ git add -f debug.log
  
$ git commit -m "Force adding debug.log"
```

### Reference

- [Pushing commits to a remote repository](https://docs.github.com/en/get-started/using-git/pushing-commits-to-a-remote-repository)
- [Push commits to another branch](https://stackoverflow.com/questions/13897717/push-commits-to-another-branch)
- [Git Stash](https://www.atlassian.com/git/tutorials/saving-changes/git-stash)
- [.gitignore](https://www.atlassian.com/git/tutorials/saving-changes/gitignore)

### How to reach out to me
- Ins: [@lcho____](https://www.instagram.com/lcho____/)
- Linkedin: [Hugo ChunHo Lin](https://www.linkedin.com/in/1chooo/)
- GitHub: [1chooo](https://github.com/1chooo)
- About me: [1chooo](https://sites.google.com/g.ncu.edu.tw/1chooo)
- Email: hugo970217@gmail.com