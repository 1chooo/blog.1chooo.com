---
title: 如何透過 map() 讓你的 React TypeScript 專案更加優雅？
categories: CodingTips
date: 2024-02-15 00:00:00
tags: 
- React
- Frontend
- map
- TypeScript
cover: /images/cover/coding-tips/make-your-react-more-elegant-with-map.png
---

{% notel blue Note %}
透過 React TypeScript 和 `map()` 方法打造更優雅的個人部落格。在這篇文章中，我分享了如何利用 `map()` 方法來處理部落格文章列表的動態渲染，並展示了 ChatGPT 提供的修改建議和實作過程中的思考。

{% endnotel %}


2024 年的寒假，我本就規劃著要再重新更新我的履歷以及個人網頁，因此在 GitHub 找到了很符合我目前需求的 Portfolio 設計 codewithsadee/vcard-personal-portfolio，本想著就照著作者的模板將自己的資訊換上就好，但是作者提供的模板沒有更多的部落格文章瀏覽設計，所有網頁內容都是在同個 index.html 裡，如果把關於我的內容塞滿載入時間太久了，因此我想說那就把每個分頁都變成一個路由去處理，可是又覺得可以來玩玩看 ReactTS，於是就開始了我的部落格爆改之旅。

本篇我想分享我是如何透過 map() 使我的 React 專案更為整潔的過程，以及我是如何透過 ChtGPT 給予我修改建議，以及輔助我實作出來的過程。

![透過 map() 動態渲染成果](https://miro.medium.com/v2/format:webp/1*KkNkB-tsC-ktJ9d76GhKIA.png)

原先的部落格頁面的寫法是這樣的：

```tsx
<ul className="blog-posts-list">
  <li className="blog-post-item  active"
    data-filter-item
    data-category="unboxing"
  >
    <a
      href="https://medium.com/@1chooo/%E5%BF%98%E6%8E%89-youtube-premium-%E9%80%99%E4%BA%9B%E7%84%A1%E5%BB%A3%E5%91%8A%E7%80%8F%E8%A6%BD%E5%99%A8%E8%AE%93%E4%BD%A0%E6%84%9B%E4%B8%8D%E9%87%8B%E6%89%8B-901f7d15a59a"
      target="_blank"
      rel="noopener noreferrer"
    >
      <figure className="blog-banner-box">
        <img
          src={noAdsImage}
          alt="No ads"
          loading="lazy"
        />
      </figure>
      <div className="blog-content">
        <div className="blog-meta">
          <p className="blog-category">Unboxing</p>
          <span className="dot"></span>
          <time dateTime="2022-02-23">Feb 11, 2024</time>
        </div>
        <h3 className="h3 blog-item-title">
          忘掉 YouTube Premium！這些無廣告瀏覽器讓你愛不釋手！
        </h3>
        <p className="blog-text">
          在這個廣告橫行的 YouTube 時代，享受影片卻不被廣告干擾的感覺真是太棒了！透過 Brave 瀏覽器，我終於找到了解脫的方法，而且完全不必花錢購買 Premium。讓我們一起換個方式，享受無廣告的 YouTube 世界吧！
        </p>
      </div>
    </a>
  </li>

  <li
    className="blog-post-item  active"
    data-filter-item
    data-category="devops"
  >
    <a
      href="https://medium.com/@1chooo/%E8%B8%8F%E5%85%A5-git-%E7%9A%84%E4%B8%96%E7%95%8C-%E4%BD%BF%E7%94%A8-ssh-%E8%88%87-github-%E9%80%A3%E7%B7%9A-7324b01349dd"
      target="_blank"
      rel="noopener noreferrer"
    >
      <figure className="blog-banner-box">
        <img
          src={gitTipsImage}
          alt="Git Tips Image"
          loading="lazy"
        />
      </figure>
      <div className="blog-content">
        <div className="blog-meta">
          <p className="blog-category">DevOps</p>
          <span className="dot"></span>
          <time dateTime="2022-02-23">Fab 23, 2022</time>
        </div>
        <h3 className="h3 blog-item-title">
          踏入 Git 的世界：使用 ssh 與 GitHub 連線 👨🏻‍💻
        </h3>
        <p className="blog-text">
          兼顧安全及隱私，利用 ssh key，push 到 GitHub 再也不需要打密碼了🔑
        </p>
      </div>
    </a>
  </li>
  {/* Rest of the blog post item */}
</ul>
```

由上方程式碼我們可以看出，如果需要新增更多文章，那我們的文章會變得非常的冗長，於是我便詢問 ChatGPT：「這樣檔案太長了，你會有什麼建議改寫？因為目前功能是互相關連的，我是 .tsx」

於是乎 ChatGPT 幫我找到了這些 blog-post-item 裡面的重複程式碼，並且建議我可以透過 map() 來處理，於是我便開始了我的改寫之旅。

首先是先建立一個 interface 來把重複的資訊給模組化，因為每個 <li></li> 裡都有這些重複的內容，包括了 title, category, imageUrl, date, content, link，因此先將 Post 的型別給構建出來：

```tsx
interface Post {
  title:    JSX.Element;
  category: string;
  imageUrl: string;
  date:     string;
  content:  JSX.Element;
  link:     string;
  alt:      string;
}
```

接著是依據剛剛建立的 interface Post把 Post 會用到的資料存成可以取用的陣列 postData：


```tsx
const postsData: Post[] = [
  {
    title: (
      <h3 className="h3 blog-item-title">
        如何透過 <code>map()</code> 讓你的 <code>React TypeScript</code> 專案更加優雅？
      </h3>
    ),
    category: 'Projects',
    imageUrl: reactMappingTipsImage,
    date: 'Fab 15, 2024',
    content: (
      <p className="blog-text">
        透過 <code>React TypeScript</code> 和 <code>map()</code>  方法打造更優雅的個人部落格。在這篇文章中，我分享了如何利用 <code>map()</code>  方法來處理部落格文章列表的動態渲染，並展示了 ChatGPT 提供的修改建議和實作過程中的思考。
      </p>
    ),
    link: 'https://medium.com/@1chooo/%E5%A6%82%E4%BD%95%E9%80%8F%E9%81%8E-map-%E8%AE%93%E4%BD%A0%E7%9A%84-react-typescript-%E5%B0%88%E6%A1%88%E6%9B%B4%E5%8A%A0%E5%84%AA%E9%9B%85-f1e5bdca1710',
    alt: '如何透過 map() 讓你的 React TypeScript 專案更加優雅？'
  },
  {
    title: (
      <h3 className="h3 blog-item-title">
        忘掉 YouTube Premium！這些無廣告瀏覽器讓你愛不釋手！
      </h3>
    ),
    category: 'Unboxing',
    imageUrl: noAdsImage,
    date: 'Feb 11, 2024',
    content: (
      <p className="blog-text">
        在這個廣告橫行的 YouTube 時代，享受影片卻不被廣告干擾的感覺真是太棒了！透過 Brave 瀏覽器，我終於找到了解脫的方法，而且完全不必花錢購買 Premium。讓我們一起換個方式，享受無廣告的 YouTube 世界吧！
      </p>
    ),
    link: 'https://medium.com/@1chooo/%E5%BF%98%E6%8E%89-youtube-premium-%E9%80%99%E4%BA%9B%E7%84%A1%E5%BB%A3%E5%91%8A%E7%80%8F%E8%A6%BD%E5%99%A8%E8%AE%93%E4%BD%A0%E6%84%9B%E4%B8%8D%E9%87%8B%E6%89%8B-901f7d15a59a',
    alt: '忘掉 YouTube Premium！這些無廣告瀏覽器讓你愛不釋手！',
  },
];
```

如此一來，我們就可以透過 map() 來將 postsData 裡的資料給取出來，並且將重複的程式碼給簡化：

```tsx
<ul className="blog-posts-list">
  {postsData.map((
    post: Post,
    index: number
  ) => (
    <li
      key={index}
      className={`blog-post-item active`}
      data-filter-item
      data-category={post.category.toLowerCase()}
    >
      <a
        href={post.link}
        target="_blank"
        rel="noopener noreferrer"
      >
        <figure className="blog-banner-box">
          <img
            src={post.imageUrl}
            alt={post.alt}
            loading="lazy"
          />
        </figure>
        <div className="blog-content">
          <div className="blog-meta">
            <p className="blog-category">{post.category}</p>
            <span className="dot"></span>
            <time dateTime={post.date}>{post.date}</time>
          </div>
          {post.title}
          {post.content}
        </div>
      </a>
    </li>
  ))}
</ul>
```

有了這樣的改寫之後，我們就可以透過 postsData 來新增更多的文章，而不用擔心程式碼會變得非常的冗長，這樣的改寫方式也讓我們的程式碼更為整潔，並且更容易維護。

最後也想分享我這次實作出來的感想，本想說把原本作者的寫法直接全部放到 ReactComponent 裡全部 return 出來，成功在網頁上顯示就好，不過後來發現這樣我每要新增一個文章的內容，我的 Component 裡的程式碼一次就要新增快三十行，然而這些程式碼都是重複的（做同樣事情）好在有請 ChatGPT 幫我做 Code Review，提出了使用 map() 的建議，也讓初嘗試 React 開發的我，有機會更認識這個框架，最後祝大家「龜年龍 🐲 某 BUG 啦！」
