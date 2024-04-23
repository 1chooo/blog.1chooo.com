---
title: "AWS: 用 AWS Lambda Function 開發 Serverless Line Bot - 1"
categories: Project
date: 2024-04-23 00:00:00
tags: 
- AWS
- Lambda Function
- Serverless
- API Gateway
- Line Bot
cover: /images/cover/projects/line-bot-with-aws-lambda-functions-1.png
---

過去在撰寫 Line Bot 我都是使用 Python 並且搭配後端框架，使用過 FastAPI 以及 Flask 做開發，都需要架起一個 Server 才能讓我們的 Line Bot 成功運行，此外還需要一台機器不斷地去幫我們運作才能處理 Line Bot 的請求，因此我轉向思考 Line Bot 的特性，Line Bot 就是透過用戶的傳遞訊息加以觸發回應，我們可以總結成三大要素：「用戶」、「觸發」、「回應」這三個關鍵字，因此我就想到了 AWS Lambda + API Gateway 的特性，當今天有用戶傳遞訊息給 Line Bot 時，透過 AWS Lambda Function 來觸發回應，這樣不就不需要架設 Server 了，還可以達成 Serverless 的概念，使用者用多少付多少，不用讓 Server 一直運作著。


我們將使用 `linebot.v3` 用以開發，並且使用 AWS Lambda Function 部署 Line Bot。以 AWS 作為範例，本篇將以 echo Bot 作為 Serverless Line Bot 的 Demo 講述設計原理以及 AWS 的使用，接著我們將介紹如何在 Serverless 的 Line Bot。

### 使用 Flask 建構 Line Bot

我們需要先觀察，過去我們使用 Flask 建構一個 Line Bot 會需要的程式碼 (參考 [line-bot-sdk](https://github.com/line/line-bot-sdk-python) example - [flask-echo](https://github.com/line/line-bot-sdk-python/tree/master/examples/flask-echo))

#### Flask app

透過 Flask 建立一個 Line Bot 的 Server，並且設定一個 `/callback` 的路由，當 Line Bot 收到用戶的訊息時，會透過 `/callback` 這個路由去承接 POST 請求。

```python
from flask import Flask, abort, request

app = Flask(__name__)

@app.route("/callback", methods=['POST'])
def callback():
    # get X-Line-Signature header value
    signature = request.headers['X-Line-Signature']

    # get request body as text
    body = request.get_data(as_text=True)
    app.logger.info("Request body: " + body)

    # handle webhook body
    try:
        handler.handle(body, signature)
    except InvalidSignatureError:
        app.logger.info("Invalid signature. Please check your channel access token/channel secret.")
        abort(400)

    return 'OK'

if __name__ == "__main__":
    app.run(port=8080)
```

#### Line Bot WebhookHandler

有了 Flask app 的 `callback` 路由，我們就可以透過 Line Bot SDK 的 `WebhookHandler` 來處理用戶的訊息，並且回應給用戶。

```python
import os

from flask import Flask, abort, request
from linebot.v3 import WebhookHandler
from linebot.v3.exceptions import InvalidSignatureError
from linebot.v3.messaging import (ApiClient, Configuration, MessagingApi,
                                  ReplyMessageRequest, TextMessage)
from linebot.v3.webhooks import MessageEvent, TextMessageContent

configuration = Configuration(access_token=os.environ["CHANNEL_ACCESS_TOKEN"])
handler = WebhookHandler(os.environ["CHANNEL_SECRET"])

@handler.add(MessageEvent, message=TextMessageContent)
def handle_message(event):
    with ApiClient(configuration) as api_client:
        line_bot_api = MessagingApi(api_client)
        line_bot_api.reply_message_with_http_info(
            ReplyMessageRequest(
                reply_token=event.reply_token,
                messages=[TextMessage(text=event.message.text)]
            )
        )
```

看完了上述範例程式的原理之後，發 呼叫 `/callback` 這個路由就使使用 Web API 去完成我們要的動作！也就是這個關鍵，其實我們可以直接用 AWS Lambda + API Gateway 來取代 flask 的 Web Server，這樣就不需要架設 Server 了，接下來我們就來看看如何使用 AWS Lambda Function 部署 Line Bot。

### 使用 AWS Lambda Function 部署 Line Bot

因為 Line Bot 會需要 `line-bot-sdk` 進行開發，這對 AWS Function 來說需要第三方函式庫，我們便需要將需要的函示庫打包成 Lambda Layer 形式上傳，以此讓我們的 Lambda Function 可以引用這些函式庫。

我們這次選用的 Python Runtime 是 Python3.12，[運行在 Amazon Linux 2023 Amazon Machine Image (AMI) 上。因此我們要確保 Layer 是可以在 Amazon Linux 2023 操作系統上運行的](https://repost.aws/knowledge-center/lambda-import-module-error-python)，因此我們打包第三方套件的方式會跟從前不一樣。

以下是我們打包 `line-bot-sdk` 的方式：

```bash
$ mkdir -p lambda-layer/python
$ cd lambda-layer/python
$ pip3 install --platform manylinux2014_x86_64 --target . --python-version 3.12 --only-binary=:all: line-bot-sdk

$ cd ..
$ zip -r ./lambda_layers/linebot_lambda_layer.zip python
```

製作好後，我們就可以上傳 Layer 到 AWS Lambda Function，接著我們就可以開始撰寫 Line Bot 的 Lambda Function。

#### lambda_handler

我們可以把 lambda_handler 想成當初的 `callback/` 路由，負責將承接從 Line Bot 過來的請求，並且可以透過 `WebhookHandler` 來處理用戶的訊息，可以想像成我們的主程式運行的地方。

```python
def lambda_handler(event, context):
    try: 
        body = event['body']
        signature = event['headers']['x-line-signature']
        handler.handle(body, signature)
        return {
            'statusCode': 201,
            'body': json.dumps('Hello from Lambda!')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(str(e))
        }
```

#### Line Bot WebhookHandler

有了可以承接請求的 `lambda_handler`，我們就可以透過 Line Bot SDK 的 `WebhookHandler` 來處理用戶的訊息，並且回應給用戶。我們做的是將 Text 相關的訊息做處理，並且回傳給用戶。

```python
import os

from linebot.v3 import WebhookHandler
from linebot.v3.messaging import (ApiClient, Configuration, MessagingApi,
                                  ReplyMessageRequest, TextMessage)
from linebot.v3.webhooks import MessageEvent, TextMessageContent

configuration = Configuration(
    access_token=os.getenv('CHANNEL_ACCESS_TOKEN'))
handler = WebhookHandler(os.getenv('CHANNEL_SECRET'))

@handler.add(MessageEvent, message=TextMessageContent)
def handle_message(event):
    with ApiClient(configuration) as api_client:
        line_bot_api = MessagingApi(api_client)
        
        line_bot_api.reply_message_with_http_info(
            ReplyMessageRequest(
                reply_token=event.reply_token,
                messages=[TextMessage(text=event.message.text)]
            )
        )
```

### 實作流程與細節

在我們了解到如何使用 AWS Lambda Function 部署 Line Bot 之後，我們就可以開始實作了，以下是我們的實作流程與細節以及架構圖：

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/arch.png)

#### 建立 Line Bot

前往 [Line Business 登入管理頁面](https://account.line.biz/login?redirectUri=https%3A%2F%2Fmanager.line.biz%2F)，登入後直接點擊建立

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/01.png)

進到 「聊天」前往回應設定頁面

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/02.png)

接著點擊「Messaging API」

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/03.png)

進入設定頁面，並且向下滑找到 [Line Developers](https://developers.line.biz/) 點擊後找到 [Console](https://developers.line.biz/console/) 進入，我們要拿到 Channel Secrets 以及 Channel Access Token 可以想像我們要拿到 Line Bot 的鑰匙。

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/04.png)


我們進去 Console 後直接往下就可以找到 Channel Secrets，可以先複製起來我們待會需要用。

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/05.png)

再來我們去 Messaging API 頁面滑到最下面找到 Channel Access Token，這是我們的 Line Bot 的身份證，我們待會也需要用。

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/06.png)

#### 建立 AWS Lambda Function

前往 [AWS Console](https://aws.amazon.com/tw/console/) 登陸，並且進到 Lambda 頁面（可自行選擇 Region），點擊建立函式

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/07.png)

可自行命名 `function-name` Runtime 選擇 `Python3.12` Architecture 選擇 `x86_64`，並且點擊建立函式。

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/08.png)

#### 連結 Layer

建立好 Lambda Function 後我們需要為我們的 Function 加上裝備，也就是我們要能夠支援第三的函式庫，因此我們要前往 Layer 頁面，點擊建立 Layer。

可以透過以下腳本建立 `linebot_lambda_layer.zip` 的 Layer

```bash
$ mkdir -p lambda-layer/python
$ cd lambda-layer/python
$ pip3 install --platform manylinux2014_x86_64 --target . --python-version 3.12 --only-binary=:all: line-bot-sdk

$ cd ..
$ zip -r ./lambda_layers/linebot_lambda_layer.zip python
```

也可以直接透過 👉🏻 [Download linebot_lambda_layer](https://raw.githubusercontent.com/1chooo/aws-educate-101-line-bot/main/lambda_layers/linebot_lambda_layer.zip) 直接下載

{% note warning  %}
**⚠️ 注意**

我們是用 `x86_64` 作為 Architect，如果當初選 arm 可能會出現 error
{% endnote %}

可自行設定名稱、描述，直接透過上傳 `.zip` 的方式，Architecture 選擇 `x86_64`，Runtime 選擇 `Python3.12`，並且點擊建立 Layer。

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/09.png)

最後幫我回到 Lambda Function 拉到最下面點擊新增 Layer，並且選擇 `Custom Layer` 即可連結 Layer。

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/10.png)

#### 編輯 Lambda Function

有了以上的設定之後我們就可以把之前所寫好的 lambda_handler 貼上去，記得要點擊 `Deploy` 否則不會生效。

```python
import json
import os

from linebot.v3 import WebhookHandler
from linebot.v3.messaging import (ApiClient, Configuration, MessagingApi,
                                  ReplyMessageRequest, TextMessage)
from linebot.v3.webhooks import MessageEvent, TextMessageContent


configuration = Configuration(
    access_token=os.getenv('CHANNEL_ACCESS_TOKEN'))
handler = WebhookHandler(os.getenv('CHANNEL_SECRET'))

@handler.add(MessageEvent, message=TextMessageContent)
def handle_message(event):
    with ApiClient(configuration) as api_client:
        line_bot_api = MessagingApi(api_client)
        
        line_bot_api.reply_message_with_http_info(
            ReplyMessageRequest(
                reply_token=event.reply_token,
                messages=[TextMessage(text=event.message.text)]
            )
        )

def lambda_handler(event, context):
    try: 
        body = event['body']
        signature = event['headers']['x-line-signature']
        handler.handle(body, signature)
        return {
            'statusCode': 200,
            'body': json.dumps('Hello from Lambda!')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(str(e))
        }
```

再來我們要把之前從 Line 拿到的鑰匙 `CHANNEL_ACCESS_TOKEN` 以及 `CHANNEL_SECRET`，設定成為環境變數。

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/11.png)

#### 設定 API Gateway

前往 API Gateway 頁面，點擊建立 API，並且選擇 `REST API`，點擊建立 API，可行命名 API 的名稱。

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/12.png)

創建好後我們要 Create Method 並且選擇 `POST`，並且點擊建立。

Method Type 選擇 `POST`，Integration Type 選擇 `Lambda function`，勾選 `Use Lambda Proxy integration`，並且選擇剛剛建立的 Lambda Function，並且點擊建立。

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/13.png)

{% note warning  %}
**⚠️ 注意**

一定要勾選 Use Lambda Proxy integration，如果勾選起來的話，會將其他 Http request Header 中的資訊也帶入 AWS Lambda，如果沒勾選 AWS Lambda 只會收到 Body tag 中的值。因為 Line Bot 會需要用到在 header 中的 **x-line-signature**，所以會需要勾選此選項。
{% endnote %}

建立好後，回到 API Gateway 頁面，點擊 Deploy API，並且選擇 New Stage，輸入 `prod` 點擊 Deploy，我們會拿到一個連結，這個連結就是我們的 API Gateway 的 Endpoint，我們要把這個 Endpoint 貼到 Line Bot 的 Webhook URL。

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/14.png)

#### 設定 Line Bot Webhook URL

我們將剛剛拿到的 API Gateway 的 Endpoint 貼到 Line Bot 的 Webhook URL，就可以開始使用 Line Bot 了。我們需要回到[Line Developers Console](https://developers.line.biz/console/) 進入，前往到 Messaging API 分頁，貼上我們的 Webhook URL 並且要點擊 `Allow Webhook`，這樣我們的 Line Bot 就可以開始運作了。

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/15.png)

### Demo

最後我們看 Demo 吧！

![](/images/post/projects/line-bot-with-aws-lambda-functions-1/demo.jpg)

恭喜大家完成了 Serverless Line Bot 的部署，這樣就不需要架設 Server 了，也可以達成 Serverless 的概念，使用者用多少付多少，不用讓 Server 一直運作著。不過大家會不會覺得機器人只會回應我們傳的內容有點太單調，下一篇我們將會介紹如何在我們的 Line Bot 中加入 Large Language Model 達到更高的互動性。

### 後記

這篇真的花了非常多的時間，讓我想起了之前在 AWS 擔任校園大使準備技術工作坊的時光，希望這篇文章能夠帶給大家認識雲的開發，並且也能成功完成一個 Line Bot 的小 project。另外工商一下這屆大使正在籌辦 證照的計畫，如果有對於最入門的 [AWS Certified Cloud Practitioner（CCP）](https://aws.amazon.com/certification/certified-cloud-practitioner/)和技術相關的 [AWS Certified Solutions Architect - Associate（SAA）](https://aws.amazon.com/tw/certification/certified-solutions-architect-associate/)有興趣的朋友都可以透過 👉🏻 [報名連結](https://www.surveycake.com/s/6dWGq)，加入證照陪跑計劃！
