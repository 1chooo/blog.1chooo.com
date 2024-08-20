---
title: 提升 Next.js 效能：把重複載入的元件放入 global layout
categories: Frontend
date: 2024-08-20 00:00:00
tags: 
- React
- Typescript
- Next.js
cover: /images/cover/frontend/move-shared-components-to-global-layout.png
---


我們今天也是來分享前端工程的相關技術，畢竟目前仍然努力地為我的網站 [1chooo.com](https://1chooo.com) 增加新的功能，以及償還過去的技術債 😢，在我的網站中，每個頁面都會共用 NavBar 來導引到不同的分頁，同時也會有 SideBar 來讓大家取得我的個人資訊，不過在過去的實作中，我每個頁面的 Component 中都包含了重複的元素，也就是說我只要切換頁面，這些重複的資訊就要重新載入一次，有時候網路不穩定的時候，還會造成圖片無法加載的問題，因此我想透過這次的篇幅來介紹我做了什麼改動。

因為目前挑選的是 [Next.js](https://nextjs.org/) 作為我的前端框架，並搭配 [React](https://react.dev/) 來開發頁面上的 Components，想知道為什麼選擇 [Next.js](https://nextjs.org/) 的朋友可以看過去的這篇文章 -- [讓老舊的 Create React App (CRA) 支援 TypeScript 5.x 吧！](https://medium.com/@1chooo/%E8%AE%93%E8%80%81%E8%88%8A%E7%9A%84-create-react-app-cra-%E4%BE%86%E6%94%AF%E6%8F%B4-typescript-5-x-ab8dbff5ac92)因此我觀察到了在 [Next.js](https://nextjs.org/) 的專案結構之中（以我的[專案](https://github.com/1chooo/1chooo.com)為例）：

```ts
...
├── app/
│   |── portfolio/
│   |   └── page.tsx    // Portfolio
│   |── page.tsx        // Home
│   └── layout.tsx
└── components/
```

頁面的路由 (App Router) 是透過 `app/` 目錄下的檔案來定義的，每個頁面要載入哪些 components 也是藉由這些檔案來加入的，同時我們可以看到在 `app/` 目錄下有一個 `layout.tsx` 的檔案，這個檔案就是我們要放置共用元件的地方，也就是 Global Layout 的存在，有點像是過去的 `index.html` 一樣，因此這次就是我下手的地方。

接著我們來觀察一下我的頁面組成，以 `about` 以及 `portfolio` 頁面為例：

`app/page.tsx`:

```tsx
const About = () => {
  const pathname = usePathname();

  return (
    <main>
      <SideBar />
      <div className="main-content">
        <NavBar />
        <article
          className={`about ${pathname === '/' ? 'active' : ''}`}
          data-page="about"
        >
          <Header title="About Hugo 👨🏻‍💻" />
          <AboutText />
          <GitHubStats />
          <TechStack />
          <LifeStyles />
        </article>
      </div>
    </main>
  );
}

export default About
```

`app/portfolio/page.tsx`:

```tsx
const Portfolio = () => {
  const pathname = usePathname();

  useEffect(() => {
    initializeCustomSelect(filterItemsByCategory);
    document.title = "Portfolio - Hugo ChunHo Lin (1chooo) | Open Source Enthusiast";
  }, []);

  return (
    <main>
      <SideBar />
      <div className="main-content">
        <NavBar />
        <article
          className={`portfolio ${pathname === '/portfolio' ? 'active' : ''}`}
          data-page="portfolio"
        >
          <Header title="Hugo's Portfolio" />
          <Projects />
        </article>
      </div>
    </main>
  );
}

export default Portfolio
```

我重複寫了兩次的 `NavBar` 以及 `SideBar`，因此我可以把 `<article>` 這個 Tag 當成我傳入 layout 的 props，這樣就可以避免重複載入的問題，同時我也可以避免掉 Copy-paste Programming 接著我們來看看我如何改動：


我先設計一個新的 Component -- PageContent 可以用來組裝我的頁面元素，並且可以讓我設定頁面的 document title、載入特定 css 檔案等等：

```tsx
import React, { useEffect } from 'react';
import Header from '@/components/header';

const PageContent: React.FC<{
  documentTitle: string;
  title: string;
  children: React.ReactNode;
  page?: string;
  pathName?: string;
}> = ({ documentTitle, title, children, page, pathName }) => {

  
  // Check if the page is at root and should not have a specific `data-page` value.
  const isRootPage = pathName === '/' && page === 'about';
  
  if (isRootPage) {
    documentTitle = "Hugo ChunHo Lin (1chooo) | Open Source Enthusiast";
  }
  
  useEffect(() => {
    document.title = documentTitle;
  }, [documentTitle]);

  return (
    <article
      className={`${page} ${isRootPage || (pathName === `/${page}`) ? 'active' : ''}`}
      data-page={isRootPage ? '' : page}
    >
      <Header title={title} />
      {children}
    </article>
  );
};

export default PageContent;
```

我有特別做了例外處理，那就是 `About` 就是在 Root 不會有 `/about` 的路徑，因此我特別寫了一個判斷來讓 `About` 正常顯示。

接著我們就可以把重複的元件放入 `layout.tsx` 中：

`app/layout.tsx`:

``` diff
  <body>
    <Hello />
+   <main>
+     <SideBar />
+     <div className="main-content">
+       <NavBar />
+       {children}
+     </div>
+   </main>
  </body>
```

另外改寫一下 `About` 以及 `Portfolio` 的頁面：

`app/page.tsx`:

```tsx
const About = () => {
  const pathname = usePathname();

  return (
    <PageContent
      documentTitle=''
      title={abouts.header}
      page="about"
      pathName={pathname}
    >
      <AboutText />
      <GitHubStats />
      <TechStack />
      <LifeStyles />
    </PageContent >
  );
}

export default About
```

app/portfolio/page.tsx
```tsx
const Portfolio = () => {
  const pathname = usePathname();

  useEffect(() => {
    initializeCustomSelect(filterItemsByCategory);
  }, []);

  return (
    <PageContent
      documentTitle='Portfolio'
      title="Hugo's Portfolio"
      page="portfolio"
      pathName={pathname}
    >
      <Projects />
    </PageContent>
  );
}

export default Portfolio;
```

做到這邊算是大功告成啦！我們已經把 `NavBar` 以及 `SideBar` 移入 `layout.tsx` 中，並且讓傳入的 `children` 可以用我們剛剛設計好的 `PageContent` 來包裝，這樣我們進入頁面就能一次把 `NavBar` 以及 `SideBar` 載入，還不需要在每個分頁都重寫一次，如果想看更多本次改動的更多細節，可以參考以下的 [PR](https://github.com/1chooo/1chooo.com/pull/114) 喔！

最後，感謝大家跟我一起學習前端的技術，如果有更多實作上的細節，我將會繼續分享在我的 Blog 上，也歡迎大家來我的網頁的 GitHub Repo --  [1chooo.com](https://github.com/1chooo/1chooo.com) 看更多的實作細節，謝謝大家！

