[中文版说明](README.md)  
In English
# Gemini2TG

Gemini2TG is a project that deploys Google Gemini's API to a Telegram bot, giving you your own AI bot.  
1. This script integrates Google Gemini Pro and Google Gemini Pro Vision, eliminating the need for manual switching.  
2. When entering text, it uses Google Gemini Pro, and for image with text, it uses Gemini Pro Vision.  
3. Additionally, Google Gemini Pro supports contextual understanding.

## Obtaining API Key

Before you start using Gemini2TG, you need to obtain a Google API key.

1. Click here to get the Google Gemini API [Get Google Gemini API](https://makersuite.google.com/app/apikey).
2. Click here to get the Telegram bot API [Get Telegram bot API](https://telegram.me/BotFather).

## Installation and Configuration

I am using Ubuntu
```#bash
wget -O gemini2tg.sh https://raw.githubusercontent.com/zhuchangyi/Gemini2tg/main/gemini2tg.sh && chmod +x gemini2tg.sh && ./gemini2tg.sh
```
## Samples
![text test](https://github.com/zhuchangyi/Gemini2tg/blob/main/test.png "test")
![vison test](https://github.com/zhuchangyi/Gemini2tg/blob/main/vision_test.png "vison_test")
