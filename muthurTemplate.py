#import logging
from telegram import Update
from telegram.ext import ApplicationBuilder, ContextTypes, CommandHandler
from telegram.ext import ContextTypes, MessageHandler, ApplicationHandlerStop, TypeHandler, Application
from telegram.ext import filters
import azure.cognitiveservices.speech as speechsdk
import sys
import beepy as beep

#Telegram setup

AllowedUsers = [ALLOWEDUSERS]  # Allowed users

#Azure TTS setup

# Creates an instance of a speech config with specified subscription key and service region.
# Replace with your own subscription key and service region (e.g., "westus").
speech_key, service_region = "SPEECHKEY", "SERVICEREGION"
speech_config = speechsdk.SpeechConfig(subscription=speech_key, region=service_region)

# Creates a speech synthesizer using the default speaker as audio output.
speech_synthesizer = speechsdk.SpeechSynthesizer(speech_config=speech_config)

async def callback(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if update.effective_user.id in AllowedUsers:
        pass
    else:
        await update.effective_message.reply_text("Hey " + update.effective_user.id + "! You are not allowed to use this bot!")
        raise ApplicationHandlerStop

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await context.bot.send_message(chat_id=update.effective_chat.id, text="This bot sends voice messages over a PMR radio, use /say to send.")

async def help(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await context.bot.send_message(chat_id=update.effective_chat.id, text="/say <text> - sends <text> over the PMR\r\n/help - this message")

async def say(update: Update, context: ContextTypes.DEFAULT_TYPE):
    # Synthesizes the received text to speech.
    # The synthesized speech is expected to be heard on the speaker with this line executed.
    beep.beep(sound='ready')
    #result = speech_synthesizer.speak_text_async(' '.join(context.args)).get()
    ssml = "<speak version='1.0' xml:lang='en-US' xmlns='http://www.w3.org/2001/10/synthesis' " \
        "xmlns:mstts='http://www.w3.org/2001/mstts'>" \
        "<voice name=\"en-US-CoraNeural\">" \
        "<mstts:express-as style=\"sad\" styledegree=\"2\">" \
        "<prosody rate=\"-10%\" pitch=\"-5%\">" \
        + ' '.join(context.args) + \
        "</prosody></mstts:express-as></voice></speak>"
    result = speech_synthesizer.speak_ssml_async(ssml).get()
    #if result.reason == speechsdk.ResultReason.SynthesizingAudioCompleted:
    if result.reason == speechsdk.ResultReason.SynthesizingAudioCompleted:
        await context.bot.send_message(chat_id=update.effective_chat.id, text="Broadcast: " + ' '.join(context.args))
    elif result.reason == speechsdk.ResultReason.Canceled:
        cancellation_details = result.cancellation_details
        if cancellation_details.reason == speechsdk.CancellationReason.Error:
            if cancellation_details.error_details:
                await context.bot.send_message(chat_id=update.effective_chat.id, text="Unable to broadcast!: {}".format(cancellation_details.error_details))

async def unknown(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await context.bot.send_message(chat_id=update.effective_chat.id, text="Sorry, I didn't understand that command, try /help for a list.")

if __name__ == '__main__':
    application = ApplicationBuilder().token('TELEGRAMTOKEN').build()
    handler = TypeHandler(Update, callback) # Making a handler for the type Update
    application.add_handler(handler, -1) # Default is 0, so we are giving it a number below 0
    start_handler = CommandHandler('start', start)
    application.add_handler(start_handler)
    help_handler = CommandHandler('help', help)
    application.add_handler(help_handler)
    say_handler = CommandHandler('say', say)
    application.add_handler(say_handler)
    unknown_handler = MessageHandler(filters.COMMAND, unknown)
    application.add_handler(unknown_handler)
    application.run_polling()
