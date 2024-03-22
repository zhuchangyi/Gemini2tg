FROM python:3.10-slim

RUN apt-get update && apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /app

RUN git clone https://github.com/zhuchangyi/Gemini2tg.git .

COPY config.json .

RUN pip install --upgrade pip && \
    pip install python-telegram-bot==13.13 Pillow && \
    pip install -q -U google-generativeai

COPY requirements.txt* ./
RUN if [ -f "requirements.txt" ]; then pip install -r requirements.txt; fi

CMD ["python", "script.py"]
