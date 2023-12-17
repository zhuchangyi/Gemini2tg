#!/bin/bash
mkdir gemini
cd gemini/
sudo apt-get update
sudo apt-get install python3.9
python3.9 -m venv gemini2tg
source gemini2tg/bin/activate
GITHUB_REPO_URL="https://github.com/zhuchangyi/Gemini2tg/blob/main"
REQUIREMENTS_FILE="requirements.txt"
PYTHON_SCRIPT="script.py"
wget "$GITHUB_REPO_URL/$REQUIREMENTS_FILE" || curl -O "$GITHUB_REPO_URL/$REQUIREMENTS_FILE"
if [ -f "$REQUIREMENTS_FILE" ]; then
    pip install -r "$REQUIREMENTS_FILE"
else
    echo "Failed to solve environments"
fi
pip install python-telegram-bot==13.13
echo "Finish environment installing"
read -p "Enter your Google API Key: " GOOGLE_API_KEY
read -p "Enter your Telegram API Key: " TELEGRAM_API_KEY
cat <<EOF >config.json
{
    "GOOGLE_API_KEY": "$GOOGLE_API_KEY",
    "TELEGRAM_API_KEY": "$TELEGRAM_API_KEY"
}
EOF
echo "Configurations saved to config.json"
wget "$GITHUB_REPO_URL/$PYTHON_SCRIPT" || curl -O "$GITHUB_REPO_URL/$PYTHON_SCRIPT"
if [ -f "script.py" ]; then
    echo "Python script downloaded successfully."
else
    echo "Failed to download the Python script."
fi
chmod +x script.py
nohup ./script.py 

