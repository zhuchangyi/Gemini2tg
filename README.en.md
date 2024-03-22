[中文版说明](README.md)  
In English
# Gemini2TG

Gemini2TG is a project that deploys Google Gemini's API to a Telegram bot, giving you your own AI bot.  
1. This script integrates Google Gemini Pro and Google Gemini Pro Vision, eliminating the need for manual switching.  
2. When entering text, it uses Google Gemini Pro, and for image with text, it uses Gemini Pro Vision.  
3. Additionally, Google Gemini Pro supports contextual understanding.
4. You can start a new chat when sending "/start" to your bot

## Obtaining API Key

Before you start using Gemini2TG, you need to obtain a Google API key.

1. Click here to get the Google Gemini API [Get Google Gemini API](https://makersuite.google.com/app/apikey).
2. Click here to get the Telegram bot API [Get Telegram bot API](https://telegram.me/BotFather).

## Installation and Configuration 
### Docker 
```#bash
wget -O setup.sh https://raw.githubusercontent.com/zhuchangyi/Gemini2tg/main/setup.sh && chmod +x setup.sh && ./setup.sh
wget -O Dockerfile https://raw.githubusercontent.com/zhuchangyi/Gemini2tg/main/Dockerfile
```
```#bash
docker build -t gemini2tg .
docker run -v "$(pwd)/config.json:/app/config.json" gemini2tg
```
### On system
I am using Ubuntu
```#bash
wget -O gemini2tg.sh https://raw.githubusercontent.com/zhuchangyi/Gemini2tg/main/gemini2tg.sh && chmod +x gemini2tg.sh && ./gemini2tg.sh 
```
## To stop running the script  
```#bash
SCRIPT_NAME="script.py"
PID=$(ps aux | grep $SCRIPT_NAME | grep -v "grep" | awk '{print $2}')
if [ -z "$PID" ]; then
    echo "Process not found."
else
    echo "Killing process with PID: $PID"
    sudo kill $PID
fi
```
## Samples
![text test](https://github.com/zhuchangyi/Gemini2tg/blob/main/test.png "test")
![vison test](https://github.com/zhuchangyi/Gemini2tg/blob/main/vision_test.png "vison_test")
