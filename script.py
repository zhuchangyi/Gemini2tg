import pathlib
import textwrap
import json
import os
import logging
from io import BytesIO

from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import (
    Updater,
    CommandHandler,
    CallbackQueryHandler,
    MessageHandler,
    Filters,
    CallbackContext,
)
import google.generativeai as genai
import PIL.Image

def to_markdown(text):
    """
    Converts text to Markdown format suitable for Telegram.
    Replaces bullet points and indents text.
    """
    text = text.replace('•', '  *')
    return textwrap.indent(text, '> ')

# Setup logging
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', 
    level=logging.INFO
)
logger = logging.getLogger(__name__)

# Load configuration
try:
    with open("config.json") as config_file:
        config = json.load(config_file)
        google_api_key = config.get("GOOGLE_API_KEY")
        telegram_api_key = config.get("TELEGRAM_API_KEY")
    if not google_api_key or not telegram_api_key:
        raise ValueError("One or more API keys are missing in config file.")
except FileNotFoundError:
    logger.error("config.json file not found.")
    raise
except json.JSONDecodeError:
    logger.error("config.json contains invalid JSON.")
    raise

# Set environment variables
os.environ["GOOGLE_API_KEY"] = google_api_key
os.environ["TELEGRAM_API_KEY"] = telegram_api_key

# Configure Google GenAI
genai.configure(api_key=google_api_key)
chat_model = genai.GenerativeModel('gemini-pro')
vision_model = genai.GenerativeModel('gemini-pro-vision')

def start(update: Update, context: CallbackContext):
    """
    Handles the /start command. Initializes a new chat for the user.
    """
    user_id = update.effective_user.id
    context.user_data['chat'] = chat_model.start_chat(history=[])
    update.message.reply_text("Hello! I am your chatbot. Send me a message to start.")

def handle_message(update: Update, context: CallbackContext):
    """
    Handles incoming text messages. Sends the user's message to the chat model and replies with the response.
    """
    user_message = update.message.text
    user_id = update.effective_user.id

    # Retrieve or initialize the chat for this user
    chat = context.user_data.get('chat')
    if chat is None:
        chat = chat_model.start_chat(history=[])
        context.user_data['chat'] = chat
        logger.info(f"Initialized new chat for user {user_id}")

    # Send the user's message to the chat model
    try:
        response = chat.send_message(user_message)
        response_text = response.text if hasattr(response, 'text') else "Sorry, I couldn't process your request."
    except Exception as e:
        logger.error(f"Error sending message to chat model: {e}")
        response_text = "An error occurred while processing your request."

    # Send the response back to the user
    update.message.reply_text(response_text, parse_mode='Markdown')

def handle_photo(update: Update, context: CallbackContext):
    """
    Handles incoming photo messages. Sends the photo to the vision model along with an optional caption.
    """
    photo = update.message.photo[-1]
    user_id = update.effective_user.id

    # Download the photo
    try:
        file = context.bot.get_file(photo.file_id)
        file_path = f'photo_{user_id}.jpg'
        file.download(file_path)
        img = PIL.Image.open(file_path)
    except Exception as e:
        logger.error(f"Error downloading or opening photo: {e}")
        update.message.reply_text("Failed to download the photo. Please try again.")
        return

    # Get the caption or use a default prompt
    user_message = update.message.caption or "What's in the picture? Watch carefully and describe all details."

    # Send the image and message to the vision model
    try:
        response = vision_model.generate_content([user_message, img], stream=False)
        response.resolve()
        response_text = response.text if hasattr(response, 'text') else "Sorry, I couldn't process the image."
    except Exception as e:
        logger.error(f"Error processing image with vision model: {e}")
        response_text = "An error occurred while processing the image."

    # Clean up the downloaded photo
    try:
        os.remove(file_path)
    except OSError as e:
        logger.warning(f"Could not remove photo file {file_path}: {e}")

    # Send the response back to the user
    update.message.reply_text(response_text, parse_mode='Markdown')

def error_handler(update: object, context: CallbackContext):
    """
    Logs errors caused by Updates.
    """
    logger.error(msg="Exception while handling an update:", exc_info=context.error)

def main():
    """
    Starts the Telegram bot and sets up handlers.
    """
    TOKEN = os.getenv("TELEGRAM_API_KEY")
    if not TOKEN:
        logger.error("TELEGRAM_API_KEY is not set.")
        return

    updater = Updater(TOKEN)
    dp = updater.dispatcher

    # Register handlers
    dp.add_handler(CommandHandler("start", start))
    dp.add_handler(MessageHandler(Filters.photo, handle_photo))
    dp.add_handler(MessageHandler(Filters.text & ~Filters.command, handle_message))

    # Register the error handler
    dp.add_error_handler(error_handler)

    # Start the bot
    updater.start_polling()
    logger.info("Bot started. Listening for updates...")

    # Run the bot until you press Ctrl-C or the process receives SIGINT, SIGTERM or SIGABRT
    updater.idle()

if __name__ == '__main__':
    main()
