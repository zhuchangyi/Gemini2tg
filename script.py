#!/root/gemini/gemini2tg/bin/python
import pathlib
import textwrap
from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import Updater, CommandHandler, CallbackQueryHandler, MessageHandler, Filters, CallbackContext
import google.generativeai as genai
import json
import os
import logging
import PIL.Image
from io import BytesIO
def to_markdown(text):
  text = text.replace('•', '  *')
  return Markdown(textwrap.indent(text, '> ', predicate=lambda _: True))
# Used to securely store your API key

with open("config.json") as config_file:
    config = json.load(config_file)
    google_api_key = config.get("GOOGLE_API_KEY")
    telegram_api_key = config.get("TELEGRAM_API_KEY")
if google_api_key is None or telegram_api_key is None:
    raise ValueError("One or all API keys are not found in config file.")

os.environ["GOOGLE_API_KEY"] = google_api_key
os.environ["TELEGRAM_API_KEY"] = telegram_api_key

# 设置日志
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)
google_api_key=os.getenv('GOOGLE_API_KEY')
genai.configure(api_key=google_api_key)
model = genai.GenerativeModel('gemini-pro')
#modelone = genai.GenerativeModel('gemini-pro-vision')

chat = model.start_chat(history=[])
def start(update, context):
    update.message.reply_text("Hello! I am your chatbot. Send me a message to start.")
def handle_message(update: Update, context: CallbackContext):
    user_message = update.message.text
    response = chat.send_message(user_message)
    response_text = response.text if hasattr(response, 'text') else "Sorry, I couldn't process your request."

    update.message.reply_text(response_text)
def handle_photo(update: Update, context: CallbackContext):
    photo = update.message.photo[-1]
    file = context.bot.get_file(photo.file_id)
    file.download('photo.jpg')
    img = PIL.Image.open('photo.jpg')

    user_message = update.message.caption or "What's in the picture? Watch carefully and describe all details."

    vision_model = genai.GenerativeModel('gemini-pro-vision')

    response = vision_model.generate_content([user_message, img], stream=False)
    response.resolve()

    # Send response back to user
    update.message.reply_text(textwrap.indent(response.text, '> '))
def main():
    TOKEN = os.getenv("TELEGRAM_API_KEY")
    updater = Updater(TOKEN, use_context=True)
    dp = updater.dispatcher
    dp.add_handler(CommandHandler("start", start))
    dp.add_handler(MessageHandler(Filters.text & ~Filters.command, handle_message))
    # Add handler for photo messages first
    dp.add_handler(MessageHandler(Filters.photo, handle_photo))
    # Add handler for text messages

    updater.start_polling()
    updater.idle()

if __name__ == '__main__':
    main()