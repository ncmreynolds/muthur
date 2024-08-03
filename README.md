# MU|TH|UR
A set of instructions for making a simple Telegram bot that does text-to-speech on a Raspberry Pi. It is intended for use at LARP or other experience events where you wish to quickly type something out on your phone and have it come out of an audio system of some kind. We don't all have voice actors on tap so the next best thing is text-to-speech.

This was obviously inspired by the many 'sad computers who tell you bad news' in sci-fi media e.g. HAL, MU|TH|UR, Gerty and so on.

## How it works

Very broadly...

- You create a Telegram Bot account using Telegram's standard tools
- A Python script running on a Raspberry Pi acts for this bot and is listening to commands you send in a group chat
- Any command prefixed with '/say' (a typical bot command) is sent to Microsoft Azure AI services text-to-speech
- The synthesised speech comes out of the default audio output of the Raspberry Pi

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

## Setting up the Telegram account

## Setting up the Microsoft Azure account

## Setting up the Raspberry Pi

If you're completely new to using a Raspberry Pi, look at the getting started information [here](https://www.raspberrypi.com/documentation/computers/getting-started.html#getting-started-with-your-raspberry-pi).

The Raspberry Pi Foundation have a convenient installation program, the Raspberry Pi Imager, which you can [download](https://www.raspberrypi.com/software/) to install the operating system Raspbian to your SD card.

Use the instructions [here](https://www.raspberrypi.com/documentation/computers/getting-started.html#install-using-imager) to install the version of Raspbian suitable for the Pi hardware you have. When you get to the 'Choose OS' step don't simply select the standard desktop installation. From the menu choose 'Raspberry Pi OS (other)' and then 'Raspberry Pi OS Lite (64-bit)'. Be very sure there's nothing on the SD card you are using as it will be completely wiped.

When offered the choice to customise the OS settings be sure to do so, as outlined [here](https://www.raspberrypi.com/documentation/computers/getting-started.html#advanced-options). You will need the Raspberry Pi to have Internet access so connect it to your Wi-Fi and you should set a proper username and password.

