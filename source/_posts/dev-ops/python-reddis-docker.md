---
title: 透過 Docker 打包 FastAPI 與 Redis 的服務串流
categories: DevOps
date: 2024-04-15 00:00:00
tags: 
- Docker
- Python
- Redis
cover: /images/cover/dev-ops/python-reddis-docker.png
---

當今天我們要自架一個服務的時候，我們會需要後端的 Server 以及需要 Database 來保存服務的內容，因此我們今天將透過 Docker 包裝 Redis 以及 Python FastAPI 來實作一個簡單的服務。

### 創建專案

首先我們要開始撰寫 Python FastAPI 的程式碼，不過在開始之前我們要先建立我們的虛擬環境並且安裝我們所需的 dependencies。（我們的 Python 環境是 Python 3.11，以及所需的套件是 fastapi, uvicorn, redis, python-dotenv）

```bash
$ mkdir my-fastapi-redis    # 建立專案資料夾

$ cd my-fastapi-redis       # 進入專案資料夾

$ python3 -m venv venv      # 建立虛擬環境

$ source venv/bin/activate  # 啟動虛擬環境

$ pip install fastapi uvicorn redis python-dotenv requests   # 安裝所需套件
```

我們的專案結構會如以下：

```
PROJECT_ROOT
├── app/
│   ├── __init__.py
│   └── main.py
├── scripts/
│   ├── run.sh
│   └── test.sh
├── test/
│   └── test_api.py
├── .env
├── docker-compose.yml
├── Dockerfile
└── README.md
```

### 實作 FastAPI 與 Redis

再來我們可以透過 [Docker](https://www.docker.com/) 來啟動 [Redis](https://redis.io/) 服務，這裡我們使用 [Redis 官方提供的 Docker Image](https://hub.docker.com/_/redis) 來啟動 Redis 服務，我們會將預設的 6379 port 對應到本地端的 6379 port。

```bash
$ docker run --name my-redis -p 6379:6379 -d redis
```

我們可以透過以下指令來確認 Redis 服務是否正常運作，我們先進入 Redis 的 Container 內部，再透過 `redis-cli` 來操作 Redis。

```bash
$ docker exec -it my-redis sh
```

查看 Redis 的 key，並且試著新增一個 key-value pair，以及刪除 key。

```bash
redis-cli
127.0.0.1:6379> keys *
(empty array)
127.0.0.1:6379> SET key1 value1
OK
127.0.0.1:6379> keys *
1) "key1"
127.0.0.1:6379> DEL key1
(integer) 1
```

接著我們可以開始撰寫我們的 FastAPI 程式碼，我們會透過 FastAPI 來實作一個簡單的 API，這個 API 會透過 Redis 來儲存資料，我們的目的是能夠新增 Item、刪除 Item、以及列出所有的 Item。

```python
# 新增 item 至 Redis
@app.post("/items/", status_code=status.HTTP_201_CREATED)
async def create_item(item: Item):
    # Add item to the Redis list
    redis_cli.rpush("items", item.name)
    return {"message": "Item added successfully"}


# 取得 Redis 內的所有 items
@app.get("/items/", status_code=status.HTTP_200_OK)
async def get_items():
    # Retrieve items from the Redis list
    items = redis_cli.lrange("items", 0, -1)
    return {"items": items}


# 刪除 Redis 內的特定 item
@app.delete("/items/{item_name}", status_code=status.HTTP_200_OK)
async def delete_item(item_name: str):
    # Delete a specific item from the Redis list
    if item_name not in redis_cli.lrange("items", 0, -1):
        raise HTTPException(status_code=404, detail="Item not found")
    redis_cli.lrem("items", 0, item_name)
    return {"message": f"Item '{item_name}' deleted successfully"}
```

完整的程式碼如下，我們會需要 `.env` 檔案來設定 Redis 的 Host 以及 Port，預設是 `REDIS_HOST=localhost` 以及 `REDIS_PORT=6379`。

```python
# app/main.py
import os

import redis
from dotenv import find_dotenv, load_dotenv
from fastapi import FastAPI, status
from pydantic import BaseModel
from fastapi.exceptions import HTTPException

app = FastAPI()

# Connect to Redis
_ = load_dotenv(find_dotenv())
REDIS_HOST = os.environ.get('REDIS_HOST')
REDIS_PORT = os.environ.get('REDIS_PORT')
redis_cli = redis.Redis(
    host=REDIS_HOST, port=REDIS_PORT, 
    decode_responses=True
)


class Item(BaseModel):
    name: str

@app.get("/", status_code=status.HTTP_200_OK)
async def root():
    return {"message": "Hello World"}


# 新增 item 至 Redis
@app.post("/items/", status_code=status.HTTP_201_CREATED)
async def create_item(item: Item):
    # Add item to the Redis list
    redis_cli.rpush("items", item.name)
    return {"message": "Item added successfully"}


# 取得 Redis 內的所有 items
@app.get("/items/", status_code=status.HTTP_200_OK)
async def get_items():
    # Retrieve items from the Redis list
    items = redis_cli.lrange("items", 0, -1)
    return {"items": items}


# 刪除 Redis 內的特定 item
@app.delete("/items/{item_name}", status_code=status.HTTP_200_OK)
async def delete_item(item_name: str):
    # Delete a specific item from the Redis list
    if item_name not in redis_cli.lrange("items", 0, -1):
        raise HTTPException(status_code=404, detail="Item not found")
    redis_cli.lrem("items", 0, item_name)
    return {"message": f"Item '{item_name}' deleted successfully"}
```

### 測試 API

接著我們要撰寫一些 unittest 去測試我們的 API，我們會透過 requests 來發送 HTTP request 並且驗證回傳的 response 是否符合預期。

```python
# test/test_api.py
import unittest
import requests
import json

class TestItemEndpoint(unittest.TestCase):
    base_url = "http://localhost:8080/items/"

    def test_create_items(self):
        data = {"name": "item1"}
        response = requests.post(self.base_url, headers={"Content-Type": "application/json"}, data=json.dumps(data))
        self.assertEqual(response.status_code, 201)

        data = {"name": "item2"}
        response = requests.post(self.base_url, headers={"Content-Type": "application/json"}, data=json.dumps(data))
        self.assertEqual(response.status_code, 201)

    def test_get_items(self):
        response = requests.get(self.base_url)
        self.assertEqual(response.status_code, 200)

    def test_delete_item(self):
        response = requests.delete(self.base_url + "item1")
        self.assertEqual(response.status_code, 200)

    def test_get_items_after_deletion(self):
        response = requests.get(self.base_url)
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(len(data), 1)  # Assuming only one item left after deletion

if __name__ == '__main__':
    unittest.main()
```

當然我們也可以直接透過 `curl` 直接獲取 API 的 response。

```bash
$ curl -X POST "http://localhost:8080/items/" -H "Content-Type: application/json" -d '{"name": "item1"}'
$ curl -X POST "http://localhost:8080/items/" -H "Content-Type: application/json" -d '{"name": "item2"}'
$ curl -X GET "http://localhost:8080/items/"
$ curl -X DELETE "http://localhost:8080/items/item1"
$ curl -X GET "http://localhost:8080/items/"
$ curl -X GET "http://localhost:8080/items/"
```

不過既然有 unittest 那我們就用 unittest 來測試我們的 API 吧。最後我們要加上 `run.sh` 以及 `test.sh` 來方便我們執行程式以及測試。

```bash
# scripts/run.sh
uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload
```

```bash
# scripts/test.sh
python test/test_*.py
```

我們依序透過 `scripts/run.sh` 以及 `scripts/test.sh` 來啟動我們的服務以及測試我們的 API。完成會如下的畫面。

![](/images/post/dev-ops/python-reddis-docker/python-reddis-docker-demo.png)

### 打包服務

最後就是我們要把我們的所有服務打包啦！

我們先將我們的 Dockerfile 寫好，這裡我們使用 Python 3.11 的 slim-buster 作為基底，並且安裝所需的套件，最後我們會將我們的程式碼複製到 Docker Container 內部，並且啟動 FastAPI 服務。

```yaml
# Dockerfile
FROM python:3.11-slim-buster

WORKDIR /app

RUN pip install uvicorn redis python-dotenv requests

COPY . /app

EXPOSE 8080

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
```

再來我們會使用到 `docker-compose` 來管理我們的服務，這裡我們會使用到 Redis 以及 FastAPI 兩個服務，我們會將 Redis 的 6379 port 對應到本地端的 6379 port，以及 FastAPI 的 8080 port 對應到本地端的 8080 port。並且會有個虛擬的網路 `hugo-network` 來連接兩個服務。

```yaml
version: '3'

services:
  redis:
    image: redis:latest
    container_name: redis
    restart: always
    ports:
      - "6379:6379"
    networks:
      - hugo-network

  server:
    build: 
      context: .
    container_name: backend
    restart: always
    ports:
      - "8080:8080"
    networks:
      - hugo-network

volumes:
  redis-data:
   
networks:
  hugo-network:
    driver: bridge
```

最後我們只要透過 `docker-compose up -d` 就可以達到我們開發所需的效果！


{% note warning  %}
**⚠️ 注意**

因為我們的服務是把 server 跟 db 分開成不同的 container 因此我們需要注意我們的 `.env` 檔案，我們需要將 `REDIS_HOST` 設定為 `redis`，這樣我們的 FastAPI 才能連接到 Redis。
{% endnote %}

今天的內容操作就到這邊完全結束，大家可以參考 [Source Code - python-redis-docker](https://github.com/1chooo/python-redis-docker/tree/blog) 也祝大家都能成功地打包自己的服務！


### Reference

- [Using Redis with FastAPI](https://developer.redis.com/develop/python/fastapi/)
- [seymaozler/card-application](https://github.com/seymaozler/card-application)
- [Building an Authentication System with FastAPI, Redis and MySQL](https://medium.com/@seymaaozlerr/building-an-authentication-system-with-fastapi-redis-and-mysql-cc8b005b9c30)
- [FastAPI + Redis example](https://python-dependency-injector.ets-labs.org/examples/fastapi-redis.html)
- [Python: Using Redis with Docker](https://medium.com/@vmbdeveloper/python-using-redis-with-docker-0400a5b2a735)
- [How to Use the Redis Docker Official Image](https://www.docker.com/blog/how-to-use-the-redis-docker-official-image/)
- [[Python] Redis v.s Mysql 查詢實作](https://medium.com/%E7%A8%8B%E5%BC%8F%E4%B9%BE%E8%B2%A8/python-redis-v-s-mysql-%E6%9F%A5%E8%A9%A2%E5%AF%A6%E4%BD%9C-9f0cc0d9b32b)
- [Python: Redis [ Using Docker ]](https://medium.com/@bhupender.rawat4/python-redis-using-docker-45643af090db)
- [How to Use Redis With Python](https://realpython.com/python-redis/)
