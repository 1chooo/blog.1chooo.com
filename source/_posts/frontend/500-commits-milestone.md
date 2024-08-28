---
title: 打造 500 commits 的 GitHub Repository：10 個不可或缺的步驟
categories: Frontend
date: 2024-08-28 00:00:00
tags: 
- React
- Typescript
cover: /images/cover/frontend/500-commits-milestone.png
---

> 一個 500 commits 的 Side Project 是如何誕生的，跟著 Hugo 一起看下去吧！

嘿大家！我是 Hugo！現在的我剛從中央大學剛畢業，開始了我的 Gap Year，我有了很多時間維護我的 Side Project，撰寫文章、自我成長的時間，今天我想跟各位分享一個對我來說很重要的里程碑：「我的個人網頁 -- [1chooo.com](https://1chooo.com) 的 [GitHub Repository](https://github.com/1chooo/1chooo.com) 達到 [500 個 commits](https://github.com/1chooo/1chooo.com/commit/b01a0417642b3679ec87427f0c783bcaafe5e7c1) 啦 🥳」這 500 個 commits 以大型專案來說無比尋常，甚至是小巫見大巫，不過對於我的個人 side project 是一大挑戰，畢竟要持續有新功能、新的專案目標、技術債，我才能繼續更新這個 project，因此我想透過這篇文章來分享我們做了哪些努力，並且又從中學到了什麼樣的寶貴經驗以及教訓。

在進入今天的分享前，先帶大家看看我專案的成果，這個專案原先的發想就是是我想打造自己的網頁，過去我也曾經試過很多次的個人網頁架設，但是對於我想要的需求就是差了那麼一點，於是我開始透過 portfolio、personal website 的關鍵字在 GitHub 找尋符合我需求的設計，有點偷懶，不過我想這就是 Open Source 最重要的一環吧！於是我找到了符合我想要功能的個人網頁 -- [vcard-personal-portfolio](https://codewithsadee.github.io/vcard-personal-portfolio/)，這邊要特別感謝原作者 [Sadee](https://github.com/codewithsadee) 無私分享自己的專案成果，讓我可以在此基礎上進行修改。

在我的網頁上有五大頁面，分別是：**About, Resume, Portfolio, Blog, Contact**，也是我想要有的功能。

### About

呈現我自己給大家認識，並且目標給予大家良好的第一印象。

![1chooo.com/about](/images/post/frontend/500-commits-milestone/about.png)

### Resume

呈現我的專業能力，在這裡可以看到我過往的學歷、工作經驗、參加競賽的經驗。

![1chooo.com/resume](/images/post/frontend/500-commits-milestone/resume.png)

### Portfolio

我會在這裡放置我過去的作品，包含了各種類型的專案，例如：網頁、App、資料分析等等。

![1chooo.com/portfolio](/images/post/frontend/500-commits-milestone/portfolio.png)

### Blog

我會在這裡分享我的文章，囊括了技術文章、刷題經驗等等，總之就是想寫什麼就會寫什麼。

![1chooo.com/blog](/images/post/frontend/500-commits-milestone/blog.png)

### Contact

提供一個想聯絡我的管道，如果有任何問題請教或是討論都可以在這裡找到我。

![1chooo.com/contact](/images/post/frontend/500-commits-milestone/contact.png)

在看完我的網頁介紹後，我們可以開始進入正題前，想先以數據呈現來聊聊我做了哪些改動，我們可以條列出我有做過的十大 Feature：

![1chooo.com — 500 commits achieving 🥳](/images/post/frontend/500-commits-milestone/500-commit-achieving.png)

1. 重構原始碼，將原本單純的 HTML、CSS、JS，改成使用 [React](https://react.dev/) 前端框架來撰寫，並使用 [Vercel](https://vercel.com/) 來部署我的網頁。
2. 把共用的 Component，拉出來重寫，避免 Copy-Paste Programming 的情形發生。
3. 整齊易讀的 Commit Message -- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)。
4. 用 Issues 來追蹤專案的改動，並且加上 Milestone 來追蹤專案的進度。
5. 加入 Tag 管理版本不同版本的 Release。
6. 加入 Google Analytics 來追蹤使用者行為。
7. 引入 GitHub Dependency Bot 來追蹤我的專案的依賴套件是否需要升級以及是否有安全漏洞。
8. 透過 [Next.js](https://nextjs.org/) 來更新老舊 Create-React-App 的依賴。
9. 美觀的 README，以及 Document 的撰寫，讓未來的開發者可以快速上手。
10. Component 的 Unit Test，確保每個 Component 都有正確的運作。

### 重構程式碼

在原本作者 [Sadee](https://github.com/codewithsadee) 的專案中，是一頁式的網站設計，也就是說所有的內容都寫在同個 HTML 裡面，包含了頁面切換，如果要快速改動，其實只要直接做更改 HTML 的內容就好，不過這時候我就遇到了一些問題，每當我要做出改動的時候，我就要在上千行的原始碼裡面找我要調整的部分、另外載入畫面時所有的內容都會一起被載入，畢竟都寫在同個 HTML 裡面，並沒有任何頁面 Router 的切換，因此我便下定決心要整個改寫，否則以後我想加新功能、新頁面的時候，我會很被限制住、也處在整個專案的被動方。

這時候我想到了前端三大框架：[React](https://react.dev/)、[Vue](https://vuejs.org/)、[Laravel](https://laravel.com/)，我選擇了 [React](https://react.dev/) 並且搭配 [TypeScript](https://www.typescriptlang.org/)，因為這是我之前有開發經驗的前端框架，同時也找得到很多前人的經驗，因此就選擇了 React，因此我便開始了大量地改寫之旅，最首要的就是讀懂原始碼，並且把原本的 HTML、CSS、JS 都拆開，並且使用 React 的 Components 來撰寫，在初期是非常有挑戰性的，需要耗費大量的時間去理解，有些 Code 甚至需要耗費幾個星期才能完成改寫。

因為我之前有使用過，也覺得 React 的生態系很完整，有很多的套件可以使用，於是我便開始了我的改寫之旅，我把原本的 HTML、CSS、JS 都拆開，並且使用 React 來撰寫，這樣我就可以把每個頁面都拆開，並且使用 React Router 來做頁面的切換，這樣我就可以更方便的做出改動，也可以更方便的加入新功能，因此現在畫面上看到的內容都是透過 React Component 來呈現的，我也保有更多的修改空間，不會受限於原作者的設計。

### Shared Component

改寫完了是一回事，但我其實是第一次碰到前端工程的部分，我的 Components 基本上就是 return 出來的 HTML Code。於是我在自己 Code Review 的時候我就發現許多 Components 可以獨立出來，甚至是可以共用同樣的 Style，也就是說我發現了很多 Copy-Paste Programming 的情形在我的程式碼之中，其中我學到了 `map()` 的寫法，可以用傳入的參數來決定要 render 出來的 Component，這樣我就可以把重複的部分刪掉，詳細介紹可以看這篇文章 👉🏻 [如何透過 map()讓你的 React TypeScript 專案更加優雅？](https://medium.com/@1chooo/%E5%A6%82%E4%BD%95%E9%80%8F%E9%81%8E-map-%E8%AE%93%E4%BD%A0%E7%9A%84-react-typescript-%E5%B0%88%E6%A1%88%E6%9B%B4%E5%8A%A0%E5%84%AA%E9%9B%85-f1e5bdca1710)。

### Commit Message

因為我常常使用 GitHub，幾乎是我每天的日常了，因此我開始對一些細節特別在意，像是 Commit Message，常常可以看到很多 Commit Message 都是：「Update、test、Upload 等字樣」也就是說看不出這次改動的痕跡，這樣的 Commit Message 對於未來的開發者來說是非常不友善的，因此我開始學習 [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)，這是一個 Commit Message 的規範，提升了 Commit 的可讀性，也比較工整，想看更多細節可以看看這篇文章，我介紹了如何撰寫優美的 Commit Message 👉🏻 [Git Commit Message 到底怎麼寫才優美？](https://medium.com/@1chooo/git-commit-message-%E5%88%B0%E5%BA%95%E6%80%8E%E9%BA%BC%E5%AF%AB%E6%89%8D%E5%84%AA%E7%BE%8E-5b789157b549)

![Well Commit Message in 1chooo.com!!!](/images/post/frontend/500-commits-milestone/well-commits.png)

### Issues & Milestone

在專案的後期，我發現當 Commits 變多了，有些 Commit 是缺少文件做紀錄的，因此我開始透過 Issues 的形式來管理我要做出的改動，算是 Agile 的一種實踐，透過 Issues 我可以清楚的知道我要做什麼，也可以詳細預估我需要的工時，以及所需的技術（雖然我有時候還是直接 Push 到 Main Branch 哈哈！）。後來我還發現了 GitHub 還有一個 Milestone 的管理，我可以把要做的目標放在一起管理，這是在我對 Microsoft VSCode Docs 提交 PRs 時發現的，因此我立馬學起來，主要是透過日其月份去管理 Milestones，像是 August, 2024，這樣我就可以清楚的知道我這個月想要做什麼事情，就可以更有效率的管理我的專案。

![1chooo.com — August, 2024 Milestones](/images/post/frontend/500-commits-milestone/milestone.png)

### Tag

因為每次開發都有想做的不同事情，因此我也會照著 Agile 的形式去快速迭代我的產品，因此當我達成了一些我想完成的功能時，我就會 Release 新的版本編號，這樣我就可以知道我這個版本做了哪些事情，也可以知道這個版本的功能有哪些，我是遵照 `vx.x.x` 的形式去命名，分成大功能、小功能、Bug 修復等。

![1chooo.com — Releases](/images/post/frontend/500-commits-milestone/tag.png)

### Google Analytics

有時候我會滿好奇這個網頁到底有沒有人在看，還是就我自己一個人點爽的，因此我就加入了 Google Analytics 來追蹤使用者的行為，有趣的是我發現有些使用者會從美國來、有些會從印度來呢！

![1chooo.com — GA](/images/post/frontend/500-commits-milestone/ga.png)

### GitHub Dependency Bot

這是我開發到中期才發現可以加入的功能，起初只是覺得好酷怎麼別人的專案會有 Dependency Bot，後來我才發現原來這是 GitHub 提供的功能，可以幫助我追蹤我的專案的依賴套件是否需要升級以及是否有安全漏洞，每週可以定期幫我檢查 Package 的更新，避免過時的 Package 的依賴。

![Dependencies](/images/post/frontend/500-commits-milestone/dependabot.png)

### Next.js

會有 Next.js 的升級，就是因為 GitHub Dependency Bot 的幫助，他讓我發現了要升級 TypeScript 時會部署不成功，詳情可以看看這篇 👉🏻 [讓老舊的 Create React App (CRA) 支援 TypeScript 5.x 吧！](https://medium.com/@1chooo/%E8%AE%93%E8%80%81%E8%88%8A%E7%9A%84-create-react-app-cra-%E4%BE%86%E6%94%AF%E6%8F%B4-typescript-5-x-ab8dbff5ac92)因此我又一次大改我的專案，把 React 的 Router 全部改成 Next.js 的 AppRouter，這也是一大工程，畢竟 React 都還沒摸熟，又來了一個新的框架，不過我還是克服啦！本以為需要花個一兩個月，其實肝了一個週末就全部寫完了！

### README & Document

放在 GitHub 的 Project 就有一種「想讓別人看起來很專業的感覺」因此我花了很多時間去 用 [Canva](https://www.canva.com/) 去 Design 我的 Cover 同時也花了時間撰寫 Contributing Guideline，希望對這專案有興趣的人可以一同參與，把開源精神發揮出來，跟著大家一起成長。另外我也會花費時間撰寫 Document，紀錄整個專案的 Code Walkthrough，以及一些開發中所遇到的情況，這樣未來的開發者就可以快速上手，我也比較不需要去通靈自己一個月前寫了什麼爛 Code。

![1chooo.com/README](/images/post/frontend/500-commits-milestone/readme.png)

### Unit Test

最後一個 Feature 就是 Unit Test，我開始使用 [Jest](https://jestjs.io/) 來寫 Unit Test，這是我第一次寫 Unit Test，因此我也花了很多時間去學習，目前的覆蓋率還不是很高，加上我又大改 Framework 變成 Next.js，很多的 Testing 都需要重新寫，因此這是我目前正在努力的一個部分，希望可以在短期內把覆蓋率提高。

![Unit Test in 1chooo.com](/images/post/frontend/500-commits-milestone/tests.png)

### 結語

雖然到了 500 commits 這個里程碑，但是我其實還有很多想做的部分，像是完成 Blog 頁面的功能，目前仍然在償還這個技術債，因為一直想要以 Markdown 去 Render，但在一開始我完全沒有這部份的設計，如果要新增，我需要把 Components 做得更加彈性，這也是我正在努力的部分。同時還有 Render 文章數量的問題，要新增上一頁、下一頁的頁面切換。另外 Contact me 的寄信目前也還沒有完成，還在考量是不是直接串接一個 Lambda Function 還是真的寫一個 API 的 Auth 去做寄信的功能，這也是我目前正在思考的部分。

要說這個專案感受最深的就是：我深刻感受到了軟體專案的 Myth，在開發的過程中，有時候會感受到吃力，比如說要加一個新的 Feature 的時候，完全受到過去寫法的制約，這時候我常常需要花很多時間去想哪裡可以調整，又或者說有沒有更好的實踐方式。再者有很多功能到底該不該加，加了我需要很多時間，但明明現在就能用啊！有時候都需要做內心拉扯，現階段情況就是無法做到完美，要想完美就需要花更多時間，但是現有時間下，又希望要做到最好，不要失去對自我的要求，這是一個很大的挑戰，也是我在這個專案中學到的最大的一點。

未來我將持續更新以及維護這個專案，畢竟這代表我的個人形象展現，是我對於技術的一種實踐，更涵蓋了我對技術的自我要求，未來也還會有更多個 500 commits 的里程碑，大家可以持續關注我，我將繼續分享遇到的困難以及我是如何化解問題的！

大家可以點擊 Follow 關注我追蹤我的最新動態，也可以到 GitHub Repo -- [1chooo.com](https://github.com/1chooo/1chooo.com) 點擊 Star ⭐️ 來支持我，謝謝大家！我們下次見！👋🏻
