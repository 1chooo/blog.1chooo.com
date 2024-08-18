---
title: 讓老舊的 Create React App (CRA) 支援 TypeScript 5.x 吧！
categories: Frontend
date: 2024-08-10 00:00:00
tags: 
- React
- Typescript
cover: /images/cover/frontend/goodbye-react-create-app.png
---

在最近這個暑假中，我幾乎都在為了我的個人網站 -- [1chooo.com](https://1chooo.com) 做開發，把一些過去想加上卻沒時間更新的技術債補回去，過去我採用的是 [React](https://react.dev/) 搭配 [TypeScript](https://www.typescriptlang.org/) 來開發，不過最近有遇到了一些問題，其中一個就是「[我無法將 Typescript 升級到 `^5` 的版本](https://github.com/1chooo/1chooo.com/pull/76)」，會出現以下的錯誤訊息：

```typescript
npm error code ERESOLVE
npm error ERESOLVE could not resolve
npm error
npm error While resolving: react-scripts@5.0.1
npm error Found: typescript@5.5.4
npm error node_modules/typescript
npm error   typescript@"^5.5.4" from the root project
npm error   peer typescript@">= 2.7" from fork-ts-checker-webpack-plugin@6.5.3
npm error   node_modules/fork-ts-checker-webpack-plugin
npm error     fork-ts-checker-webpack-plugin@"^6.5.0" from react-dev-utils@12.0.1
npm error     node_modules/react-dev-utils
npm error       react-dev-utils@"^12.0.1" from react-scripts@5.0.1
npm error       node_modules/react-scripts
npm error         react-scripts@"5.0.1" from the root project
npm error   1 more (tsutils)
npm error
npm error Could not resolve dependency:
npm error peerOptional typescript@"^3.2.1 || ^4" from react-scripts@5.0.1
npm error node_modules/react-scripts
npm error   react-scripts@"5.0.1" from the root project
```

因此想透過本篇想紀錄的解決過程，以及相關脈絡資訊，如果電腦需要安裝 [Node.js, npm](https://nodejs.org/) 的話，可以參考我過去的文章 -- [如何在 Mac 安裝 Node.js & NPM](/2024/01/03/dev-env/mac-install-nodejs-npm/) 來安裝。

過去我建立 React 專案的方式是透過 [`create-react-app` (CRA)](https://github.com/facebook/create-react-app) 來建立，不過在這次升級的過程中，我發現 [`create-react-app`](https://github.com/facebook/create-react-app) 似乎只支援到 [`v5.0.1`](https://github.com/facebook/create-react-app/releases/tag/v5.0.1) 的版本，並且可以從 Facebook 的 GitHub Repo 中發現，目前 CRA 已經沒有人在維護了，上次更新已經是 2022 年了，所以想當然爾，現在的 CRA 沒有支援 TypeScript `5.x` 的版本，只能支援到 `4.x` 的版本，這也是為什麼我目前無法升級 TypeScript 到 `5.x` 的原因。

![create-react-app v5.0.1](/images/post/frontend/goodbye-react-create-app/create-react-app-v-5-0-1.png)

因此我就開始在網路上搜尋為什麼 CRA 不再維護，以及有沒有其他的替代方案，首先我從 [React](https://react.dev/) 的官方文件中就寫明了建立 React App 的方式沒有 `create-react-app` 這個方式，反倒是建議使用像是 [Next.js, Remix, Gatsby, Expo (for native apps), etc.](https://react.dev/learn/start-a-new-react-project) 這些框架來建立 React App，我想這也是為什麼 CRA 不再維護的原因之一。

![Start a New React Project](/images/post/frontend/goodbye-react-create-app/start-a-new-react-project.png)

我在 [Goodbye create-react-app](https://dev.to/ag2byte/create-react-app-is-officially-dead-h7o) 這篇文章中找到了一些 CRA 不再維護的原因，其中提到 CRA 這個專案已經被 Facebook 官方放棄了，主要是因為效能的關係，對於現行的方法而言太慢了，初始化的階段會花費太多時間，另外 CRA 也有一些因為過時所產生的警告，這些問題已經困擾開發者很久了，然而對於初學者來說也很難解決這些問題，因此 CRA 這個方式已經不再是最佳的選擇了。

另外我也在 [`create-react-app` (CRA)](https://github.com/facebook/create-react-app) 的 [Issues](https://github.com/facebook/create-react-app/issues/12628) 中找到一個別再用 CRA 的理由以及其他合適的建立 App 方法，總之挖掘資訊到現在，發現 CRA 基本上是被詬病已久的舊時代產物了，也是時候要更新。

不過身為軟體工程師，還是想要把問題解決，畢竟只是更新一個 Dependencies 而已，總會有解法讓我繼續使用 CRA 並且又能夠升級 TypeScript 到 `5.x` 的版本吧！於是我就找到了一個在 [`create-react-app`](https://github.com/facebook/create-react-app) 的 PR -- [(react-scripts) Support for TypeScript 5.x #13080](https://github.com/facebook/create-react-app/issues/13080)，這個 PR 也是關於 Typescript 升級不到 `5.x` 的問題，同時也有解決方法在裡面，其實只要在 `package.json` 中加入以下的 [`overrides`](https://docs.npmjs.com/cli/v8/configuring-npm/package-json#overrides) 就可以解決這個問題：

```json
"dependencies": {
    "create-react-app": "^5.0.1",
    "typescript": "^5.5.4",
},
"overrides": {
    "typescript": "^5.5.4"
},
```

這邊要特別注意，`overrides` 的版本要跟 dependencies 中 TypeScript 的版本一樣，這樣才能夠解決這個問題。如果想瞭解更多 `overrides` 的用法，可以參考 [`package.json`](https://docs.npmjs.com/cli/v8/configuring-npm/package-json#overrides) 的官方文件以了解更多。

目前到這邊已經算是成功解決 Typescript 升級到 `5.x` 的問題了，不過我覺得這樣其實治標不治本，畢竟 CRA 已經是沒有在維護的工具了，因此我也開啟了一個新的坑，那就是把我的 React App 整合到 [Next.js](https://nextjs.org/) 中，這樣就可以解決 CRA 不再維護的問題，同時也可以享受到 Next.js 的優點，這也是我接下來為自己開的新坑。

未來我會持續更新這個坑，並且把我的 React App 整合到 Next.js 中，希望可以順利完成這個整合，因為目前搜尋下來看起來是要整份重寫了⋯⋯想看更多的話可以持續關注，也可以參觀我目前的個人網站 -- [1chooo.com](https://1chooo.com)，也可以到 GitHub 上看到網站的原始碼 -- [1chooo/1chooo.com](https://github.com/1chooo/1chooo.com)，我將會持續更新，希望這篇可以幫助到需要的人喔～