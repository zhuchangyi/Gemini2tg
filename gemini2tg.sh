#!/bin/bash
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt-get update -y
sudo apt-get install python3 -y
current_python_version=$(python3 -c 'import platform; print(platform.python_version())')
required_python_version="3.9"
mkdir -p gemini
cd gemini/

if [[ $(printf '%s\n' "$required_python_version" "$current_python_version" | sort -V | head -n1) != "$required_python_version" ]]; then
    echo "current_python_version ($current_python_version) less than ($required_python_version)install python3.9"
    sudo apt-get install python3.9 -y
    sudo apt install python3.9-venv -y
    python3.9 -m venv gemini2tg
else
    echo "current_python_version ($current_python_version)>3.9"
    sudo apt install python3-venv -y
    python3 -m venv gemini2tg
fi



source gemini2tg/bin/activate


pip install python-telegram-bot==13.13
pip install Pillow
pip install -q -U google-generativeai
GITHUB_REPO_URL="https://raw.githubusercontent.com/zhuchangyi/Gemini2tg/main"
REQUIREMENTS_FILE="requirements.txt"
PYTHON_SCRIPT="script.py"
wget "$GITHUB_REPO_URL/$REQUIREMENTS_FILE" || curl -O "$GITHUB_REPO_URL/$REQUIREMENTS_FILE"
if [ -f "$REQUIREMENTS_FILE" ]; then
    pip install -r "$REQUIREMENTS_FILE"
else
    echo "Failed to solve environments"
fi
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
nohup python3.9 script.py &
nohup python3 script.py &
echo "Gemini2tg is running in the background."
