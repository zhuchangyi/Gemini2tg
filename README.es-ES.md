

[中文版说明](README.cn.md)  
# Gemini2TG

Gemini2TG es un proyecto que despliega la API de Google Gemini en un bot de Telegram, ofreciéndote tu propio bot de IA.  
1. Este script integra Google Gemini Pro y Google Gemini Pro Vision, eliminando la necesidad de cambiar manualmente.  
2. Al escribir texto, utiliza Google Gemini Pro, y para imágenes con texto, utiliza Gemini Pro Vision.  
3. Además, Google Gemini Pro admite la comprensión contextual.
4. Puedes iniciar un nuevo chat enviando "/start" a tu bot

## Obtener la clave de API

Antes de comenzar a usar Gemini2TG, necesitas obtener una clave de API de Google.

1. Haz clic aquí para obtener la API de Google Gemini [Obtener API de Google Gemini](https://makersuite.google.com/app/apikey).
2. Haz clic aquí para obtener la API del bot de Telegram [Obtener API del bot de Telegram](https://telegram.me/BotFather).

## Instalación y configuración 
### Docker 
```#bash
wget -O setup.sh https://raw.githubusercontent.com/zhuchangyi/Gemini2tg/main/setup.sh && chmod +x setup.sh && ./setup.sh
wget -O Dockerfile https://raw.githubusercontent.com/zhuchangyi/Gemini2tg/main/Dockerfile
```
```#bash
docker build -t gemini2tg .
docker run -v "$(pwd)/config.json:/app/config.json" gemini2tg
```
### En el sistema
Estoy usando Ubuntu
```#bash
wget -O gemini2tg.sh https://raw.githubusercontent.com/zhuchangyi/Gemini2tg/main/gemini2tg.sh && chmod +x gemini2tg.sh && ./gemini2tg.sh 
```
## Para detener la ejecución del script  
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
## Ejemplos 
![vison test](https://github.com/zhuchangyi/Gemini2tg/blob/main/vision_test.png "vison_test")
![text test](https://github.com/zhuchangyi/Gemini2tg/blob/main/test.png "test")
