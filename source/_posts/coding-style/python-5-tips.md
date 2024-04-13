---
title: 五個 Python 好習慣
categories: Coding Style
date: 2024-03-16 00:00:00
tags: 
- Python
- Clean Code
cover: /images/cover/coding-style/python-5-tips.png
---


在學習基礎程式語言中，我們往往只在乎程式能不能運行，會不會基礎語法，然而很多人沒有累積到專案中實際撰寫的好習慣，因此這篇文章中，我將會討論五個 Python 的好習慣，並且這些事我已經落實在專案中的 Coding Style 希望透過這次的分享能夠幫助看到這邊的你寫出更好的程式碼。

### 1. `if __name__ == '__main__':`

很多人可能在 review 別人的 Python 專案時，都會發現這個條件式。這個條件式的目的是為了確保這個檔案是被直接執行，而不是被 import 進其他檔案中，我們可以舉個例子來看看加上這個條件式的重要性。

我們今天要設計一個 `api` 是 `get_name()`，透過呼叫這個 api 我們可以得到從資料庫中取得名字，我們先來看看以下的程式碼：

```python
# api.py
import time

def get_name() -> None:
    print('Getting name...')
    time.sleep(3)
    print('Hugo')

get_name()
```

```python
# main.py
from api import get_name

get_name()
```

我們可以先觀察執行結果如以下：

```bash
Getting name...
Hugo
Getting name...
Hugo
```

總共執行了兩次 `get_name()`，但是奇怪的是我們明明只有在 `main.py` 中呼叫了一次 `get_name()`，為什麼會執行兩次呢？

因為我們在 `api.py` 中的 `get_name()` 是直接被執行的，所以當我們在 `main.py` 中 import `api.py` 時，`get_name()` 也會被執行一次。

因此我們只要把 `main.py` 改成以下的程式碼就可以解決這個問題：

```python
# main.py
from api import get_name

if __name__ == '__main__':
    get_name()
```

我們就會得到我們想要的執行結果如以下：

```bash
Getting name...
Hugo
```

這樣就不會執行兩次 `get_name()` 了，也就是說在我們的程式碼中加上 `if __name__ == '__main__':` 可以讓 Python 知道「只要」執行該檔案呼叫的程式碼，而不是從其他 import 進來的 function。

### 2. 在 Python 中加入 `main()` function

在很多程式語言中都有 `main()` function 的存在，像是 Go, C, C++, Java 等等。因為對於 Python 任何皆是物件的特性，沒有 `main()` function 也是可以執行的，不過加上 `main()` function 我們可以知道程式主要的進入點是什麼。

我們可以從以下範例程式碼觀察，這是沒有加上 `main()` function 的程式碼：

```python
# Bad Habit
def say_hello() -> None:
    print('Hello')

def say_goodbye() -> None:
    print('Goodbye')

say_hello()
say_goodbye()
```

另外我們可以看到搭配第一個好習慣的 `if __name__ == '__main__':`，再加上宣告 `main()` function，這樣我們就可以確保程式的進入點是 `main()` function，另外我們也可以確認的是執行的是該檔案呼叫的 `main()` function。

```python
# Good Habit
def say_hello() -> None:
    print('Hello')

def say_goodbye() -> None:
    print('Goodbye')

def main() -> None:
    say_hello()
    say_goodbye()

if __name__ == '__main__':
    main()
```

這時候大家可能會覺得我平常的寫法也不會出錯，何必多寫幾行呢？

我們今天要假使當你的專案越來越大時，要在幾千行之中找到主程式運行的地方是一件非常困難的事情，因此加上 `main()` function 可以讓你的程式碼更加的有組織性，並且也可以更快地釐清 scripts 的運行目的。

### 3. 避免過多的 `if` 巢狀判斷邏輯

假如我們今天上課只想點資工系的大三，我們要先判斷年級，再判斷系所，如果都有符合那就是點名成功，否則就是翹課出去爽了，我們可以看看這個 scenario 的實現：

```python
# Bad Habit
def check_attendance(grade: int, department: str) -> None:
    if grade == 3:
        if department == 'CS':
            print('Attendance success')
        else:
            print('You are not in CS department')
    else:
        print('You are not in 3rd grade')
```

這樣的寫法看起來沒有什麼問題，但是當我們的判斷條件越來越多時，這樣的寫法會讓我們的程式碼變得非常難以閱讀，我們可以透過以下的寫法來改善：

```python
# Good Habit
def is_year_three(grade: int) -> bool:
    return grade == 3

def is_cs_major(department: str) -> bool:
    return department == 'CS'

def check_attendance(grade: int, department: str) -> None:
    if is_year_three(grade) and is_cs_major(department):
        print('Attendance success')
    else:
        print('You are not in the class')
```

如此我們可以把條件給分開成不同的判斷，這樣我們如果要修改條件的話也可以直接從獨立出來的 function 進行修改，而不用去修改原本的程式碼，同時也避免同一個 function 中有過多的 `if` 巢狀判斷邏輯，造成閱讀上的困難。


### 4. 為變數加上型別提示

Python 是個不用宣告型別的程式語言，這樣的特性讓 Python 的程式碼變得非常的靈活，但是當我們接手他人的專案又或是需要快速理解程式邏輯時，我們很難一眼就看出這個變數是什麼型別，這時候我們可以透過型別提示來讓程式碼更加的易讀。

```python
number1: int = 10
number2: int = '20'

print(number1)  # 10
print(number2)  # 20
```

以上的範例中，我們可以看到 `number1` 和 `number2` 都有加上型別提示，都是 `int`，不過我們可以看到 `number2` 中，我們賦予的內容是 `'20'`，這個作法在 Python 中我們單純只是 print 出來的話是不會有問題的，但是如果我們要進行數學運算的話就會出現問題，這時候我們就可以透過型別提示來瞭解該變數該賦予的類型，以免在後續使用出問題。

```python
number1: int = 10
number2: int = '20'

print(number1 + number2)
```

錯誤訊息會如以下，會發現 `number1` 和 `number2` 的型別不同，所以無法進行運算，也就是說當初我們在宣告變數時加上型別提示，可以讓我們避免做出型別混用的錯誤。

```bash
Traceback (most recent call last):
  File "hugo/is/great/developer/python_tip_04.py", line 4, in <module>
    print(number1 + number2)
          ~~~~~~~~^~~~~~~~~
TypeError: unsupported operand type(s) for +: 'int' and 'str'
```

### 5. List Comprehension

我們在撰寫程式時，常常會需要遍歷一個 list，並且對每一個元素進行操作，這時候我們可能會需要撰寫一堆 `for` 迴圈還有 `if` 來得到我們要的資訊，這時我們就可以透過 List Comprehension 來讓我們的程式碼更加的簡潔。

當我們今天要在一個 List 找出所有的偶數，我們可以透過以下的寫法來達成：

```python
# Bad Habit
numbers = [1, 2, 3, 4, 5]
even_numbers = []

for number in numbers:
    if number % 2 == 0:
        even_numbers.append(number)

print(even_numbers) # [2, 4]
```

透過 List Comprehension 我們可以把上面的程式碼簡化成以下的寫法：

> **💡 TIP**
> 
> 這邊提供大家 List Comprehension 的記憶方法，那就是 `[目標 for 目標 in 來源 if 條件]`，這樣可以幫助大家更快理解以及上手。

```python
# Good Habit
numbers = [1, 2, 3, 4, 5]

even_numbers = [number for number in numbers if number % 2 == 0]

print(even_numbers) # [2, 4]
```

完成啦 🖐🏻！以上就是五個在 Python 中的好習慣，也是我在撰寫專案中一步一步累積到的經驗，有些也不是老師上課會教的內容，但是好習慣往往從日常最好養成，希望大家在未來的開發途中，也可以將這些技巧運用在專案中，讓程式碼更加的易讀並且更加的有組織性，未來也會持續分享更多的 Python 小技巧，請大家持續關注。
