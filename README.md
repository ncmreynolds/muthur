# MU|TH|UR
A set of instructions for making a simple Telegram bot that does text-to-speech on a Raspberry Pi. It is intended for use at LARP or other experience events where you wish to quickly type something out on your phone and have it come out of an audio system of some kind. We don't all have voice actors on tap so the next best thing is text-to-speech.

This was obviously inspired by the many 'sad computers who tell you bad news' in sci-fi media e.g. HAL, MU|TH|UR, Gerty and so on.

## How it works

Very broadly...

- You create a Telegram Bot account using Telegram's standard tools
- A Python script running on a Raspberry Pi acts for this bot and is listening to commands you send in a group chat
- Any command prefixed with '/say' (a typical bot command) is sent to Microsoft Azure AI services text-to-speech
- The synthesised speech comes out of the default audio output of the Raspberry Pi

These instructions are current as of August 2024 with Raspberry Pi OS Bookworm of that time. If a lot of time has passed and the OS has changed significantly they may need some updating please raise a GitHub issue if they cease to work.

## Prerequisites

You will need...

- A computer supported by the Microsoft Cognitives Services Speech SDK.
  - These instructions will from this point forward assume you are going to use a Raspberry Pi 3A+ or 3B+ as this was what was used in making the first example. Later or more powerful Raspberry Pi computers should also work, but the 3A+ is the sweet spot in the author's opinion as this task doesn't require much resource and is has a convenient audio/video out connector.
  - Older 32bit Raspberry Pis like the original model B or Zero are not supported as it must be a 64 bit model.
  - Some storage for the operating system installation, on a Pi a small SD card like 16GB is perfectly sufficient.
  - A suitable power supply for the Raspberry Pi. Modern Pi computers can suck a bit of power and are fussy about the supply voltage so I would recommend you buy an official Pi PSU at the same time as the Pi rather than using any old USB supply you have kicking around.
  - A screen and keyboard for initial setup. You will not need these later, the Pi can be run 'headless'.
- Internet connectivity for the computer. Setting it up on a 5G connection etc. is outside the scope of these instructions we will assume you'll have some accessible Wi-Fi etc.
- A Telegram account
- A Microsoft Azure account. The free tier is sufficient for normal use.

## Setting up the Telegram bot

You will need a Telegram account, setting up one is beyond the scope of this how-to as it is widely covered.

Once you have a Telegram account, contact the [BotFather](https://t.me/botfather) to create a new bot. Interactions with BotFather are a bit like a chat, but you use '/start' to begin.

You then create a new bot with '/newbot', you will need a 'friendly name' and an 'username', try to pick something sensible for both. The username must end in 'bot'.

Once the BotFather has made your bot it will message back and tell you the location of your bot and give you an API key which is a long string of letters and numbers, be sure to keep a record of all this as you'll need it later.

You will also need to allow the bot to join group chats and if you do '/start' again the BotFather will pop up a menu where you can set this.

## Setting up a Telegram Group chat

You can message MUTHUR directly but you probably want to add them to a group chat so everybody has the message history. Create a normal group chat called whatever you want then add the Telegram bot account to it. When you do so you **must** add the Telegram bot account as an administrator otherwise it can't see all the messages.

## Setting who can send messages to the Telegram bot

By default anybody in the world can message a Telegram bot. This could have bad consequences with spam and/or inappropriate messages coming in. The script that handles messages is set to restrict this to a set of specific accounts and you have to collect the numeric ID of every account that would like to access it.

To get these IDs message https://t.me/userinfobot in Telegram with '/start' and it will tell you your ID which will be 10+ digit number. Collect these for everybody who wants to use MUTHUR.

## Setting up the Microsoft Azure account

TBC

## Setting up the Raspberry Pi

If you're completely new to using a Raspberry Pi, look at the getting started information [here](https://www.raspberrypi.com/documentation/computers/getting-started.html#getting-started-with-your-raspberry-pi).

The Raspberry Pi Foundation have a convenient installation program, the Raspberry Pi Imager, which you can [download](https://www.raspberrypi.com/software/) to install the operating system Raspbian to your SD card.

Use the instructions [here](https://www.raspberrypi.com/documentation/computers/getting-started.html#install-using-imager) to install the version of Raspbian suitable for the Pi hardware you have. When you get to the 'Choose OS' step don't simply select the standard desktop installation. From the menu choose 'Raspberry Pi OS (other)' and then 'Raspberry Pi OS Lite (64-bit)'. Be very sure there's nothing on the SD card you are using as it will be completely wiped.

When offered the choice to customise the OS settings be sure to do so, as outlined [here](https://www.raspberrypi.com/documentation/computers/getting-started.html#advanced-options). You will need the Raspberry Pi to have Internet access so connect it to your Wi-Fi and you should set a proper username and password.

The first time the Raspberry Pi starts will take a few minutes, wait for it to get to a logon screen where it is asking for your username with a prompt that says 'login:' with a flashing cursor. Enter your username and password and you should be in.

Now you can install the MUTHUR components by entering the command...

'curl https://raw.githubusercontent.com/ncmreynolds/muthur/main/install.sh | bash'

...anybody familiar with Linux will know this is a naïve and potentially dangerous way to install things. This how-to is not for people with your level of knowledge, and obviously feel free to check the very simple script in that link before running it.

You will need to configure MUTHUR before anything will work, enter the command...

'muthur/configure.sh'

...which will prompt you for the following information.

- Your Telegram bot API token
- Your list of numerical Telegram user IDs which must be separated with commas
- Your Azure text-to-speech API key
- Your Azure text-to-speech service region

Once you've put these in it will configure MUTHUR and start the services. If you want to reconfigure things later, for example to add another user, you can do it again later.

