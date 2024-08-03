#!/usr/bin/bash
#
# This naive installation script really should contain nothing contentious folks, have a look
#

# Update all the things following a fresh OS installation
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

# Install the things needed to get going
sudo apt install -y python3-pip portaudio19-dev lame libssl1.1

# Create a Python virtual environment, which is a necessary thing now
python3 -m venv muthur

# Activate the Python virtual environment before continuing
source ~/muthur/bin/activate

# Do an installation of the Telegram bot components as per https://github.com/python-telegram-bot/python-telegram-bot
pip install python-telegram-bot --upgrade

# Do an installation of the Azure TTS components as per https://github.com/Azure-Samples/cognitive-services-speech-sdk/tree/master/quickstart/python/text-to-speech
pip install azure-cognitiveservices-speech pyaudio pydub elementpath

# Do an installation of Beepy, to make a small noise before speaking which will alert people to the voice
pip install beepy

# Get the MUTHUR files

curl https://raw.githubusercontent.com/ncmreynolds/muthur/main/muthurTemplate.py --output ~/muthur/muthurTemplate.py --silent
curl https://raw.githubusercontent.com/ncmreynolds/muthur/main/muthur.service --output ~/muthur/muthur.service --silent
curl https://raw.githubusercontent.com/ncmreynolds/muthur/main/muthur.sh --output ~/muthur/muthur.sh --silent
curl https://raw.githubusercontent.com/ncmreynolds/muthur/main/configure.sh --output ~/muthur/configure.sh --silent

#Make the necessary scripts executable
chmod +x ~/muthur/muthur.sh
chmod +x ~/muthur/configure.sh

#Update the service files to reflect the user's home directory, which should be a one-time action using hashes to separate as the path will have a /
sed -i "s#HOMEDIRECTORY#$HOME#g" ~/muthur/muthur.service