---
title: 做個小貪吃蛇來玩吧！
categories: Project
date: 2023-07-30 15:00:00
tags:
- python
- pygame
---


還記得當時剛學習程式語言的時候，對於什麼知識都不懂，連搜尋能力也沒有，常常搜不到關鍵字，問題也解決不了，不過當時懵懂無知的狀態，完成了基礎貪吃蛇的小遊戲，所以決定撰寫一篇文章來記錄當時的過程。

**本文綱要**
- [環境建置](#環境建置)
    - [官網連結：](#官網連結)
- [接著就開始建立環境吧！](#接著就開始建立環境吧)
- [實作說明](#實作說明)
- [實作感想](#實作感想)
- [（更新）專案後續發展](#更新專案後續發展)
- [重構心得](#重構心得)
  - [Source Code in GitHub: python\_snake\_game](#source-code-in-github-python_snake_game)
  - [How to reach out to me](#how-to-reach-out-to-me)

## 環境建置

實作這次的小遊戲是透過 Python 語言的套件：Pygame 來實現的，不過途中會遇到很多的版本問題，起源於 Pygame 本身版本相容性，因此我們要測試出能夠正常執行的版本，過程中不斷地嘗試，也不斷地失敗，最後才找出了解決方案，那就是透過 Conda 的環境來建置。

選擇安裝 Conda 版本，這邊選擇的是 MiniConda，因為本身不太需要原本 Conda 如此龐大的功能，因此選擇瘦身版的，再加上 Mac 的儲存空間著實珍貴啊！選用的版本為 `conda 4.12.0`，直接前往官網安裝相對應作業系統版本即可。

#### 官網連結：

[Miniconda Docs](https://docs.conda.io/en/latest/miniconda.html)

## 接著就開始建立環境吧！

我們先確認 Conda 版本，在終端機輸入 `conda --version`。

![](https://miro.medium.com/max/1400/1*1uDdGsxFlihzmPfLP6Mo4A.webp)

接著透過 Conda 建立名為 pygame 的虛擬環境，Python 的版本選用 `3.16.13` 並且激活執行該環境。

``` shell
$ conda create --name pygame python=3.6.13
$ conda activate pygame
```

確認 Python 版本，並且開始安裝我們需要的套件，如果把--user 省略，會直接安裝至 Conda 的環境。

``` shell
$ python --version
$ python3 -m pip install -U pygame --user
```

最後已經到了最後一步了，我們只要測試 pygame 能否正常運作便大功告成了，所以我們要執行 pygame 可以直接呼叫的小遊戲。

``` shell
$ python3 -m pygame.examples.aliens
```

![](https://miro.medium.com/max/1400/1*xRYWm3kCCimYkrsHfh88KA.webp)

## 實作說明

前面做了這麼多的前置作業，那我們就開始進行實作吧！我們的順序會先引入套件，設定鍵盤方向鍵的接收，最後進行一連串的遊戲玩法設定，就大功告成啦！完整程式碼都放在 GitHub 給大家參考啦！畢竟全部放進文章，會變成流水帳，最後只要在終端機輸入 python main.py ，就可以正常執行貪吃蛇小遊戲囉！

![](https://miro.medium.com/max/1400/1*okV2P3qTibFMO1NWbaRBJQ.webp)

## 實作感想

當下實作程式碼，說真的也不完全是自己的東西，大多數的東西都要透過參考他人的實作來完成，不過在程式碼實作初期，環境崩掉的時候真的很讓人崩潰，只能不斷 conda remove -n env_name -all ，一直 rebuild，不過這過程中真的可以學到很多內容，可以更了解 python 語言的版本相應關係，以及要如何管理自己電腦環境（雖然現在環境依舊混亂～嘿嘿～）。

那在程式語言方面，練習到了物件導向的概念，可以把很多東西看成是一個個的物件，並且有分類的關係，即便當時看不太懂，但還是很有成就感，畢竟這是第一個小專案，能夠感受到不斷學習的狀態，這已經夠讓我珍惜了！未來也還會繼續分享專案實作，並且做更多深入地探究，繼續在電腦科學的道路上前行、突破！

---

## （更新）專案後續發展

現在時間是 2023 年初，過新年便有項恆年不變的傳統，那就是要「除舊佈新」，想當然爾過往的專案在此刻便會重出江湖，況且現在距離上次改動專案也隔了半年以上，寫程式碼的習慣也會因為參考了更多人的寫法而有所改動，因此在原有程式架構不變的情景下，將原本的程式碼重構，寫成呼叫物件的形式，以下便會直接透過程式碼說明，另外撰寫這段文字的時候也發現 Medium 改動了嵌入程式碼的方式，現在無需上傳到 GitHub Gist 也可以將程式碼顯示有 Syntax 的樣貌了，那我們就開始展開說明吧！

* 將貪吃蛇的移動獨立成 `Direction.py`

    ``` py
    # -*- coding: utf-8 -*-

    from enum import Enum


    class Direction(Enum):

        RIGHT = 1
        LEFT = 2
        UP = 3
        DOWN = 4
    ```

* 將遊戲的主要規則程式寫入 `SnakeGame.py`

    ``` py
    # -*- coding: utf-8 -*-

    from Direction import Direction
    import pygame
    import random
    from collections import namedtuple


    pygame.init()

    font = pygame.font.Font('../src/arial.ttf', 25)
    Point = namedtuple('Point', 'x, y')

    # rgb colors
    WHITE = (255, 255, 255)
    RED = (255, 0, 0)
    BLUE1 = (0, 0, 255)
    BLUE2 = (0, 100, 255)
    BLACK = (0, 0, 0)

    BLOCK_SIZE = 20
    SPEED = 10

    class SnakeGame:

        def __init__(self, w=640, h=480):
            self.w = w
            self.h = h
            # init display
            self.display = pygame.display.set_mode((self.w, self.h))
            pygame.display.set_caption('Snake')
            self.clock = pygame.time.Clock()

            # init game state
            self.direction = Direction.RIGHT

            self.head = Point(self.w / 2, self.h / 2)
            self.snake = [self.head, Point(self.head.x - BLOCK_SIZE, self.head.y),
                        Point(self.head.x - (2 * BLOCK_SIZE), self.head.y)]

            self.score = 0
            self.food = None
            self._place_food()

        def _place_food(self):
            x = random.randint(0, (self.w - BLOCK_SIZE) // BLOCK_SIZE) * BLOCK_SIZE
            y = random.randint(0, (self.h - BLOCK_SIZE) // BLOCK_SIZE) * BLOCK_SIZE

            self.food = Point(x, y)
            if self.food in self.snake:
                self._place_food()

        def play_step(self):
            # 1. collect user input
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    pygame.quit()
                    quit()
                if event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_LEFT:
                        self.direction = Direction.LEFT
                    elif event.key == pygame.K_RIGHT:
                        self.direction = Direction.RIGHT
                    elif event.key == pygame.K_UP:
                        self.direction = Direction.UP
                    elif event.key == pygame.K_DOWN:
                        self.direction = Direction.DOWN

            # 2. move
            self._move(self.direction)  # update the head
            self.snake.insert(0, self.head)

            # 3. check if game over
            gameOver = False
            if self._is_collision():
                gameOver = True
                return gameOver, self.score

            # 4. pace new food or just move
            if self.head == self.food:
                self.score += 1
                self._place_food()
            else:
                self.snake.pop()

            # 5. update ui and clock
            self._update_ui()
            self.clock.tick(SPEED)
            # 6. return gameOver and score
            return gameOver, self.score

        def _is_collision(self):
            # hits boundary
            if self.head.x > self.w - BLOCK_SIZE or self.head.x < 0 or self.head.y > self.h - BLOCK_SIZE or self.head.y < 0:
                return True
            # hits itself
            if self.head in self.snake[1:]:
                return True

            return False

        def _update_ui(self):
            self.display.fill(BLACK)

            for pt in self.snake:
                pygame.draw.rect(self.display, BLUE1, pygame.Rect(pt.x, pt.y, BLOCK_SIZE, BLOCK_SIZE))  # 東西南北
                pygame.draw.rect(self.display, BLUE2, pygame.Rect(pt.x + 4, pt.y + 4, 12, 12))

            pygame.draw.rect(self.display, RED, pygame.Rect(self.food.x, self.food.y, BLOCK_SIZE, BLOCK_SIZE))

            text = font.render("Score: " + str(self.score), True, WHITE)
            self.display.blit(text, (0, 0))
            pygame.display.flip()

        def _move(self, direction):
            x = self.head.x
            y = self.head.y
            if direction == Direction.RIGHT:
                x += BLOCK_SIZE
            elif direction == Direction.LEFT:
                x -= BLOCK_SIZE
            elif direction == Direction.DOWN:
                y += BLOCK_SIZE
            elif direction == Direction.UP:
                y -= BLOCK_SIZE

            self.head = Point(x, y)
    ```

* 最後創建 `main.py` 呼叫所有內容，便可向原先依樣正常執行啦！

    ``` py
    # -*- coding: utf-8 -*-

    from SnakeGame import SnakeGame

    if __name__ == '__main__':
        game = SnakeGame()

        # game loop
        while True:
            gameOver, score = game.play_step()

            if gameOver == True:
                break

        print('Final Score', score)

        pygame.quit()
    ```

* 此時在終端機執行 `python3 main.py` 也會出現相同的畫面呢！

![](https://miro.medium.com/max/1400/1*okV2P3qTibFMO1NWbaRBJQ.webp)

## 重構心得
這次會想要重構程式碼，便是因為 2022 後半年使用 python3 完成了一個新的專案，也在過程中才更認識 python3 類別的應用以及開發所需注意的小細節，所以才回想起曾經做過的小專案，嘗試將後續所學到的內容更應用在程式碼撰寫上，也增加自己多一次的經驗累積。


### Source Code in GitHub: [python_snake_game](https://github.com/1chooo/junk-project/tree/main/python_snake_game)

### How to reach out to me
- Ins: [@lcho____](https://www.instagram.com/lcho____/)
- Linkedin: [Hugo ChunHo Lin](https://www.linkedin.com/in/1chooo/)
- GitHub: [1chooo](https://github.com/1chooo)
- About me: [1chooo](https://sites.google.com/g.ncu.edu.tw/1chooo)
- Email: hugo970217@gmail.com