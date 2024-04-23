---
title: Git Commit Message 到底怎麼寫才優美？
categories: DevOps
date: 2024-03-26 00:00:00
tags: 
- Git
- Commit
cover: /images/cover/dev-ops/git-good-commit-look-like.png
---


在團隊用 Git 協作中，Commit Message 是很重要的一環，好的 Commit 可以讓我們的專案更容易維護，讓我們更容易了解專案的開發過程，我們可以想像是程式碼的註解，不過是針對專案改動的註解。所以我們想要用這個篇幅來介紹一些寫 Commit 的技巧，讓我們的 Commit 更優美。


### 那到底甚麼是好的 Commit Message？

```
fix
``` 

V.S. 

```
fix: login error 

The past login router was being reused multiple times.

Fixed it to use the correct route and extracted the duplicated parts.

Issue: #1234
```

從上方的 Commit 案例中，如果都是一個月前的改動，甚至是一年前的改動，當我今天需要去了解這個改動的時候，我們可以發現第一個 Commit 是很難讓我們了解這個改動的目的，甚至是看不懂要做甚麼，而第二個 Commit 會讓我們更容易了解這個改動的目的，這就是好的 Commit Message 的重要性。

常常軟體工程師中有個迷因 [Is it normal if I can't remember how my code works after just 6 months?](https://www.quora.com/Is-it-normal-if-I-cant-remember-how-my-code-works-after-just-6-months) 就是，大家回去看自己寫的程式都看不懂，甚至會覺得噁心，因此好的 Commit 可以讓我們更容易了解過去團隊做了甚麼事情，這樣我們就可以更容易地維護專案。

![https://www.quora.com/Is-it-normal-if-I-cant-remember-how-my-code-works-after-just-6-months](/images/post/dev-ops/git-good-commit-look-like/meme.JPG)

## Commit Message 的格式

好的 Commit 應該要能夠一眼看出種類、工作內容的大鋼，更重要的是一致性，這樣我們可以更容易地追蹤開發過程。因此我們可以從以下幾個內容：我們做了甚麼努力（What）、又為什麼要做這件事情（Why）、還有是用什麼方法做到的（How）。

我們可以參考以下的格式：

```bash
Header: <TYPE>(<SCOPE>): <SUBJECT>
    - TYPE: Represents the category of the commit.
    - SCOPE: Represents the scope of the commit.
    - (Required) SUBJECT: Represents a brief description of the commit, (limited to 50 characters and should not end with a period)

Body: 72-character wrapped. This should answer:
    - Provide a detailed description of the commit. (Can be split into multiple lines, with each line limited to 72 characters.)
    - Explain the changes made in the code, and Why to do?

Footer:
    - (if applicable) Include the task number.
    - (optional) BREAKING CHANGE: Record incompatible changes. It should start with "BREAKING CHANGE:" followed by a description of the change, the reason for the change, and migration instructions.
```

### Commit Message Header: `<TYPE>(<SCOPE>): <SUBJECT>`
- TYPE: 代表 commit 的類別，如：feat, fix, docs, style, refactor, test, chore
- （可選）SCOPE：commit 影響的範圍，如：資料庫、控制層、模板層等，視專案不同改變
- （必要）SUBJECT：commit 的簡短描述，不超過 50 個字元，結尾不加句號，盡量讓 Commit 單一化，一次只更動一個主題

#### Type 的種類

Type 有以下幾種的類別，每個都會是一個動作，代表提交 Commit 的類別，以下是一些我們使用慣例：

- feat: 對專案做了哪些新增、修改 (Feature)。
- fix: 修復了那些功能 (Bug Fix)。
- docs: 對專案撰寫文件 (Documentation)。
- style: 撰寫格式改動 (不影響程式碼運行的變動 white-space, formatting, missing semi colons, et.)。
- refactor: 重構 (既不是新增功能，也不是修補 bug 的程式碼變動)。
- perf: 改善效能 (A code change that improves performance)。
- test: 增加測試 (when adding missing tests)。
- chore: 建構程序或輔助工具的變動 (maintain)。
- revert: 撤銷回覆先前的 commit 例如：revert: type(scope): subject (回覆版本：xxxx)。

### Commit Message Body

傳達「我們做了甚麼努力（What）、又為什麼要做這件事情（Why）、還有是用什麼方法做到的（How）」，描述詳細改動的內容，可以分成多行，每行不超過 72 個字元，也可以有前後改動差異的描述。

### Commit Message Footer

用來填寫相關聯 issue 的編號，像是 `Issue: #1234`。另外還有 BREAKING CHANGE（未必需要），記錄不相容的變動，應該以「BREAKING CHANGE:」開頭，後面是變動的描述、原因和遷移方法。

### 一些實際的例子

我們在現有的功能上加上了 email 驗證，我們可以使用 `feat` 來撰寫：

```
feat: email validation

We have implemented the following enhancements:

1. Introduced email validation to the login form.
2. The new feature verifies if the user's input is in a valid email format.
3. It checks if the entered email corresponds to an actual email account.
4. This update aims to prevent users from entering incorrect email addresses.
5. It improves overall user experience and data integrity.

Issue: #1234
```

今天我們需要基於過去版本做開發，我們可以使用 `revert` 來回覆先前的 Commit：
```
revert: feat: email validation

To address the issue, we have decided to revert the email validation feature to the previous version.

Issue: #2345
```

我們在準備將產品上線的時候，我們駔了幾個 unit test，我們可以使用 `test` 來撰寫：
```
test: email validation

There are several unit tests for the email validation feature:
1. Test the email validation function with invalid email addresses.
2. Test the email validation function with valid email addresses.

Issue: #3456
```

今天我們已經將新功能做好了，我們希望加上文件的說明，我們可以使用 `docs` 來撰寫：
```
docs: email validation

We have added documentation for the email validation feature:
1. Add the Tech Stack documentation.
2. Add the User Guide documentation.
3. Add the API documentation.

Issue: #4567
```

後來因為我們的用戶數量變多了，我們希望優化現有的架構提升驗證速度，我們可以使用 `perf` 來撰寫：
```
perf: email validation

We have optimized the email validation feature:
1. Improved the email validation algorithm.
2. Reduced the time required to validate email addresses.
3. Enhanced the user experience by providing faster feedback.

Issue: #5678
```


### Conclusion

Commit Message 的撰寫會需要大量的練習，也需要時間讓團隊成員去實踐，如此可以讓我們追朔過去的努力，也可以幫助團隊成員更快速地餐與開發過程，這樣我們就可以更容易地維護專案。最後祝大家一切開發都順利，也希望大家的 Commit Message 越來越優美。


### Reference
- [Git Commit Message 這樣寫會更好，替專案引入規範與範例](https://wadehuanglearning.blogspot.com/2019/05/commit-commit-commit-why-what-commit.html)
- [[學習筆記] 如何撰好的 Git Commit Message](https://heidiliu2020.github.io/git-commit-message/)