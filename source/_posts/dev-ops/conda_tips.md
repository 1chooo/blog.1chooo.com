---
title: 我在 Conda 常用的指令
categories: DEV
date: 2023-07-30 15:00:00
tags: 
- python
- venv
- conda
- tips
---

> 每次用 Conda 都要在搜尋一次嗎？以後就看這篇吧！

相信有在透過 Python 開發的朋友，對 Python 環境的設置各有喜好，而有些時候相對應的專案會需要不同的環境需求，而這時 Conda 會是很好的夥伴，不過常常在使用 Conda 的時候，常常會不知道指令是什麼，因此每次需要使用的時候必須要上網查詢，如此便多了一些步驟，如此在日常工作流程便會受到限制，因此本篇會介紹一些 Conda 常被使用的 Command 指令，讓日常的工作更為順暢。

**本文綱要**
- [建立、刪除和複製虛擬環境](#建立刪除和複製虛擬環境)
  - [建立虛擬環境](#建立虛擬環境)
  - [刪除虛擬環境](#刪除虛擬環境)
  - [複製虛擬環境](#複製虛擬環境)
- [激活與退出虛擬環境](#激活與退出虛擬環境)
- [安裝及刪除需要的 package 至虛擬環境](#安裝及刪除需要的-package-至虛擬環境)
- [查詢虛擬環境資訊](#查詢虛擬環境資訊)
- [導出虛擬環境](#導出虛擬環境)
- [文末小結](#文末小結)
- [How to reach out to me](#how-to-reach-out-to-me)

### 建立、刪除和複製虛擬環境

#### 建立虛擬環境

``` shell
$ conda create -n your_env_name python=x.x.x                    # 直接建立 python 版本為 x.x.x 的虛擬環境
$ conda create -n your_env_name matplotlib numpy python=x.x.x   # 建立虛擬環境同時一併安裝想要的 package (ex: numpy, matplotlib)
```

#### 刪除虛擬環境

``` shell
$ conda deactivate                                  # 首先必須先退出虛擬環境
$ conda remove -n your_env_name --all               # 再來得以完整刪除虛擬環境

$ conda remove --name your_env_name package_name    # 只刪除虛擬環境特定 package
```

#### 複製虛擬環境

``` shell
$ conda create new_env_name --clone old_env_name    # 透過舊環境名稱，將原有虛擬環境的內容複製，進而生成新虛擬環境
$ conda create new_env_name --clone old_env_path    # 透過舊環境路徑，將原有虛擬環境的內容複製，進而生成新虛擬環境
```

### 激活與退出虛擬環境

``` shell
$ conda activate your_env_name    # 激活目標虛擬環境
$ conda deactivate                # 退出目標虛擬環境
```

### 安裝及刪除需要的 package 至虛擬環境

``` shell
$ conda install -n your_env_name package_name   # 在目標的虛擬環境中安裝特定 package
$ conda remove -n your_env_name package_name    # 在目標的虛擬環境中刪除特定 package
```

### 查詢虛擬環境資訊

* #### 若想要更新 conda 之版本

``` shell
$ conda update conda    # 升級當前 conda 之版本
```
* #### 查看已安裝的 Conda 版本

``` shell
$ conda --version   # 第一種方法
$ conda -V          # 第二種方法
```
* #### 查看當前已建立環境列表
  
``` shell
$ conda env list    # 第一種方法
$ conda info -e     # 第二種方法
```

* #### 查看在當前環境已安裝的 package

``` shell
$ conda list  # 顯示當前虛擬環境已安裝的 package
```

### 導出虛擬環境
透過 conda 的 export 導出 .yaml 的檔案格式，將虛擬環境名稱、位址、已安裝的 package 記錄下來。

``` shell
$ conda env export > ~/env.yaml                       # 將虛擬環境名稱、位址、已安裝的 package，輸出至 ~/env.yaml
$ conda env export > your_goal_path/environment.yaml  # 將虛擬環境名稱、位址、已安裝的 package，輸出至目標的路徑中
```

接著也可以透過導出的 `.yaml` 創建新虛擬環境

``` shell
$ conda env create -f ~/env.yaml                      # 透過 ~/env.yaml 的資訊，建立新虛擬環境
$ conda env create -f your_goal_path/environment.yaml # 透過目標的路徑中的 environment.yaml 的資訊，建立新虛擬環境
```

### 文末小結

上述大多為平常使用 conda 虛擬環境常用之操作，而在文末，為不讓本篇文章看似單就普通說明書，接下來就來分享自己平時在使用 conda 虛擬環境的一些小習慣吧！我們話不多說，先上一張圖片吧！


![每次激活環境時的操作](../assets/imgs/conda_command.png "每次激活環境時的操作")

雖然是虛擬環境，可以隨時建立查看，發生錯誤也能立馬砍掉不影響其他操作進行，不過有些時候常常就因為存在太多已建立的環境，而導致混亂而發生錯誤，導致又要多花時間 Debug，所以每次我在使用虛擬環境前都會先檢查一些基本的資訊。

``` shell
$ conda --version               # 檢查當前 conda 版本
$ conda env list                # 查看當前已建立的所有虛擬環境
$ conda activate your_env_name  # 激活目標的虛擬環境
$ which python                  # 檢查 python 的路徑是否存在虛擬環境下
$ python3 --version             # 檢查當前虛擬環境下的 python 版本
$ conda list                    # 檢查當前虛擬環境下的 package
```
搭配了這些小習慣，讓我在使用虛擬環境時，比較不容易發生 call 錯環境的情形發生，也讓我在使用虛擬環境時更為順手。相信大家有了這些 conda 的常用 command，無論是工作中、研究中、日常興趣中，使用虛擬環境都能更為順手，增加工作效率。

若是還想要我再補充更多 conda 的操作，或是其他開發環境的建立，都歡迎留言一起討論哦～

### How to reach out to me
- Ins: [@lcho____](https://www.instagram.com/lcho____/)
- Linkedin: [Hugo ChunHo Lin](https://www.linkedin.com/in/1chooo/)
- GitHub: [1chooo](https://github.com/1chooo)
- About me: [1chooo](https://sites.google.com/g.ncu.edu.tw/1chooo)
- Email: hugo970217@gmail.com