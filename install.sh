#!/usr/bin/bash
#
# This naive installation script really should contain nothing contentious folks, have a look
#

# Update all the things following a fresh OS installation
echo Updating system
sudo apt update -y  -qq
sudo apt upgrade -y  -qq
sudo apt autoremove -y  -qq

# Install the things needed to get going
echo Installing needed system libraries
sudo apt install -y python3-pip portaudio19-dev lame libssl1.1

# Create a Python virtual environment, which is a necessary thing now
echo Creating virtual envinronment for MUTHUR
python3 -m venv muthur

# Activate the Python virtual environment before continuing
source ~/muthur/bin/activate

# Do an installation of the Telegram bot components as per https://github.com/python-telegram-bot/python-telegram-bot
echo Installing Telegram bot libraries
pip install python-telegram-bot --upgrade --quiet

# Do an installation of the Azure TTS components as per https://github.com/Azure-Samples/cognitive-services-speech-sdk/tree/master/quickstart/python/text-to-speech
echo Installing Text-to-speech libraries
pip install azure-cognitiveservices-speech pyaudio pydub elementpath --quiet

# Do an installation of Beepy, to make a small noise before speaking which will alert people to the voice
echo Installing Beep library
pip install beepy --quiet

# Get the MUTHUR files
echo Downloading MUTHUR scripts
curl https://raw.githubusercontent.com/ncmreynolds/muthur/main/muthurTemplate.py --output ~/muthur/muthurTemplate.py --silent
curl https://raw.githubusercontent.com/ncmreynolds/muthur/main/muthur.service --output ~/muthur/muthur.service --silent
curl https://raw.githubusercontent.com/ncmreynolds/muthur/main/muthur.sh --output ~/muthur/muthur.sh --silent
curl https://raw.githubusercontent.com/ncmreynolds/muthur/main/configure.sh --output ~/muthur/configure.sh --silent

#Make the necessary scripts executable
chmod +x ~/muthur/muthur.sh
chmod +x ~/muthur/configure.sh

#Update the service files to reflect the user's home directory, which should be a one-time action using hashes to separate as the path will have a /
sed -i "s#HOMEDIRECTORY#$HOME#g" ~/muthur/muthur.service
sed -i "s#HOMEDIRECTORY#$HOME#g" ~/muthur/muthur.sh
echo Done