#!/bin/bash
read -p "Enter your Google API Key: " google_api_key
read -p "Enter your Telegram API Key: " telegram_api_key
echo "{\"GOOGLE_API_KEY\": \"$google_api_key\", \"TELEGRAM_API_KEY\": \"$telegram_api_key\"}" > config.json
echo "config.json file has been created."
