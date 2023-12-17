# Gemini2TG

Gemini2TG 是一个将Google Gemini的API部署到Telegram机器人的项目，让你拥有属于自己的ai机器人。  
1. 本脚本集成了Google Gemini Pro和Google Gemini Pro Vision，不需要手动切换。  
2. 输入文本的时候就是使用Google Gemini Pro，输入图片加文本就是使用Gemini Pro Vision。  
3. 并且Google Gemini Pro 支持上下文语境。




## 获取Google API密钥

在开始使用 Gemini2TG 之前，您需要获取一个Google API密钥。

1. 点击这里获取GOODLE GEMINI API [获取Google Gemini API](https://makersuite.google.com/app/apikey)。
2. 点击这里获取TELEGRAM BOT API [获取TELEGRAM BOT API](https://telegram.me/BotFather)。


## 安装与配置

我用的系统是Ubuntu
```#bash
wget -O gemini2tg.sh https://raw.githubusercontent.com/zhuchangyi/Gemini2tg/main/gemini2tg.sh && chmod +x gemini2tg.sh && ./gemini2tg.sh 
```
脚本会自动配置python环境，过程中会要求用户输入2个apikey，脚本运行成功后就与自己的bot聊天啦。
## samples  
![text test](https://github.com/zhuchangyi/Gemini2tg/blob/main/test.png "test")
![vison test](https://github.com/zhuchangyi/Gemini2tg/blob/main/vision_test.png "vison_test")







