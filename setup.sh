#!/bin/bash
read -p "Enter your Google API Key: " GOOGLE_API_KEY
read -p "Enter your Telegram API Key: " TELEGRAM_API_KEY
cat <<EOF >config.json
{
    "GOOGLE_API_KEY": "$GOOGLE_API_KEY",
    "TELEGRAM_API_KEY": "$TELEGRAM_API_KEY"
}
EOF
echo "Configurations saved to config.json"
