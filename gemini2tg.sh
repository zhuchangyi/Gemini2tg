#!/bin/bash
REPO_URL="https://github.com/zhuchangyi/Gemini2tg.git"
SCRIPT_NAME="script.py"

sudo apt-get update -y
sudo apt-get install git -y

git clone $REPO_URL
REPO_DIR=$(basename $REPO_URL .git)
cd $REPO_DIR


LOG_FILE="./gemini2tg_install.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $@" | tee -a "$LOG_FILE"
}


sudo add-apt-repository -y ppa:deadsnakes/ppa

sudo apt-get install python3 -y
current_python_version=$(python3 -c 'import platform; print(platform.python_version())') 
required_python_version="3.9"



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


log "Checking Python version without environment..."
python -V 2>&1 | tee -a "$LOG_FILE"

source gemini2tg/bin/activate

log "Checking Python version within environment..."
python -V 2>&1 | tee -a "$LOG_FILE"

pip install python-telegram-bot==13.13
pip install Pillow
pip install -q -U google-generativeai
REQUIREMENTS_FILE="requirements.txt"
PYTHON_SCRIPT="script.py"

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

log "Checking installed pip packages..."
pip list 2>&1 | tee -a "$LOG_FILE"


if [ -f "script.py" ]; then
    echo "Python script downloaded successfully."
else
    echo "Failed to download the Python script."
fi
chmod +x script.py
nohup python3 script.py &
echo "Gemini2tg is running in the background."
