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

- A Raspberry Pi supported by the Microsoft Cognitives Services Speech SDK.
  - These instructions will from this point forward assume you are going to use a Raspberry Pi 3A+ or 3B+ as this was what was used in making the first example. Later or more powerful Raspberry Pi computers should also work, but the 3A+ is the sweet spot in the author's opinion as this task doesn't require much resource and it has a convenient audio/video out connector unlike a Zero 2W.
  - Older 32bit Raspberry Pis like the original model B or Zero are not supported as it must be a 64 bit model.
  - Some storage for the operating system installation, a small SD card like 16GB is perfectly sufficient.
  - A suitable power supply for the Raspberry Pi. Modern Pi computers can suck quite a bit of power especially at startup and are fussy about the supply voltage so I would recommend you buy an official Pi PSU at the same time as the Pi (they are not hugely expensive) rather than using any old USB supply you have kicking around. The official Pi PSU puts out a voltage at the upper rather than lower end of the acceptable range, which is why they often work better.
  - A screen and keyboard for initial setup. You will not need these later, the Pi can be run 'headless'.
- Internet connectivity for the Pi. Setting it up on a 5G connection etc. is outside the scope of these instructions we will assume you'll have some accessible Wi-Fi etc.
- A Telegram account
- A Microsoft Azure account. The free tier is sufficient for normal use.

## Setting up the Telegram bot

You will need a Telegram account, setting up one is beyond the scope of this how-to as it is widely covered.

Once you have a Telegram account, contact the [BotFather](https://t.me/botfather) to create a new bot. Interactions with BotFather are a bit like a chat, but you use '/start' to begin.

You then create a new bot with '/newbot', you will need a 'friendly name' and an 'username', try to pick something sensible for both. The username must end in 'bot'.

Once the BotFather has made your bot it will message back and tell you the location of your bot and give you an API key which is a long string of letters and numbers, be sure to keep a record of all this as you'll need it later.

You will also need to allow the bot to join group chats and if you do '/start' again the BotFather will pop up a menu where you can set this.

## Setting up a Telegram Group chat

You can message MUTHUR directly but you probably want to add them to a group chat so everybody has the message history. Create a normal group chat called whatever you want then add the Telegram bot account to it. When you do so you **must** add the Telegram bot account as an administrator otherwise it can't see the messages.

## Specifying who can send messages to the Telegram bot

By default anybody in the world can message a Telegram bot. This could have bad consequences with spam and/or inappropriate messages coming in. 

The script on the Raspberry Pi that handles messages is set to restrict this to a set of specific accounts and you have to collect the numeric ID of every account that would like to access it.

To get these IDs message https://t.me/userinfobot in Telegram with '/start' and it will tell you your ID which will be 10+ digit number. Collect these for everybody who wants to use MUTHUR.

## Setting up the Microsoft Azure account

TBC

Beware that after 30 days on the totally free trial they will expect you to add a payment method. You can continue to use the free tier after this.

## Setting up MUTHUR on the Raspberry Pi

If you're completely new to using a Raspberry Pi, look at the getting started information [here](https://www.raspberrypi.com/documentation/computers/getting-started.html#getting-started-with-your-raspberry-pi).

The Raspberry Pi Foundation have a convenient installation program, the Raspberry Pi Imager, which you can [download](https://www.raspberrypi.com/software/) to install the operating system Raspbian to your SD card.

Use the instructions [here](https://www.raspberrypi.com/documentation/computers/getting-started.html#install-using-imager) to install the version of Raspbian suitable for the Pi hardware you have. When you get to the 'Choose OS' step don't simply select the standard desktop installation as it's unnecessarily large. From the menu choose 'Raspberry Pi OS (other)' and then 'Raspberry Pi OS Lite (64-bit)'. Be very sure there's nothing you want to keep on the SD card you are using as it will be completely wiped.

When offered the choice to customise the OS settings be sure to do so, as outlined [here](https://www.raspberrypi.com/documentation/computers/getting-started.html#advanced-options). You will need the Raspberry Pi to have Internet access so connect it to your Wi-Fi and you should also set a proper username and password which you keep a record of. It may be worth setting it up to allow SSH access as well in the Service tab, as that will allow you to connect from another computer to complete the setup.

The first time the Raspberry Pi starts will take a few minutes, wait for it to get to a logon screen where it is asking for your username with a prompt that says 'login:' with a flashing cursor.

Enter your username and password at the keyboard and you should be in. Alternatively you can connect using an SSH program such a [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/) which will make entering the long API keys **much** easier as you should be able to cut and paste them from another computer. You will need the IP address of the Raspberry Pi to connect and it will helpfully show this about 6-12 lines up from the bottom of the screen. It should say something like 'My IP address is: 192.168.1.X', use the address shown on the screen to connect.

Now you can install the MUTHUR components by entering the command...

```
curl https://raw.githubusercontent.com/ncmreynolds/muthur/main/install.sh | bash
```

...anybody familiar with Linux will know this is a naïve and potentially dangerous way to install things. This how-to is not for people with your level of knowledge, and obviously feel free to check the very simple script in that link before running it.

This script may take ten minutes or more to complete as it also updates the OS install, so please be patient.

You will then need to configure MUTHUR before anything will work, enter the command...

```
muthur/configure.sh
```

...which will prompt you for the following information. These are horrible long strings, but make sure you get them right. Obviously using cut and paste from an SSH connection to the Pi makes this much easier.

- Your Telegram bot API token
- Your list of numerical Telegram user IDs which must be separated with commas
- Your Azure text-to-speech API key
- Your Azure text-to-speech service region

Once you've put these in it will configure MUTHUR and start the services. It should say 'muthur systemd[1]: Started muthur.service - muthur' once it is finished. Every time the Pi starts the MUTHUR script will start automatically.

If you want to reconfigure things later, for example to add another Telegram user, you can run the same command again.

That's it, you should be done. If you message your bot directly or the group chat it's part of with something that has '/say ' at the start then speech should just come out of the Raspberry Pi default audio output.

## Forcing audio out onto the jack plug

Depending on if you've got an HDMI screen connected or not the default audio output may change between this and the jack plug. You can force it onto the jack plug with the following command.

```
sudo raspi-config nonint do_audio 0
```

## Connecting the jack plug line out to a PMR walkie-talkie

The use case I had for this project was to feed the synthesised voice into an unmodified PMR walkie-talkie. These do not have a line in but rather a microphone connection. These two things are not compatible.

To solve this I used the small attenuation/impedence/biasing circuit from the second answer [here](https://electronics.stackexchange.com/questions/620985/line-level-to-microphone-level-to-record) on Electronics StackExchange and it worked well.

![](JxEAM.png)

On the Raspberry Pi the A/V out connector is a 4-pole 3.5mm TRRS one which is slightly unusual. It has the following pinout. You can in principle just use a 3-pole TRS connector and it shorts the composite video to ground harmlessly but I deliberately used a TRRS connector and broke the video out in case I wanted to later attach a small screen.

| Raspberry Pi jack connector | Channel         |
| --------------------------- | --------------- |
| Tip                         | Left            |
| Ring 1                      | Right           |
| Ring 2                      | Ground          |
| Shield                      | Composite video |

At the PMR end it was a 2.5mm TRS connector which is again unusual. PMRs don't have a 100% standard connector for this but there are a couple of common types.

The PMR was set to Vox activation at its most sensitive and it **mostly** picked up the output well. The 'bong' inserted before speech is specifically there to wake up the PMR and get it to start transmitting.

A future improvement would be to trigger the push-to-talk feature of the PMR from a GPIO on the Raspberry Pi as that should be more reliable.

## Customising the voice of MUTHUR

The style of voice used by MUTHUR is possible to customise using something called SSML.

You can open Telegram bot script and see this using the command.

```
nano muthur/muthur.py
```

You will see the following about halfway down.

    ssml = "<speak version='1.0' xml:lang='en-US' xmlns='http://www.w3.org/2001/10/synthesis' " \
        "xmlns:mstts='http://www.w3.org/2001/mstts'>" \
        "<voice name=\"en-US-CoraNeural\">" \
        "<mstts:express-as style=\"sad\" styledegree=\"2\">" \
        "<prosody rate=\"-10%\" pitch=\"-5%\">" \
        + ' '.join(context.args) + \
        "</prosody></mstts:express-as></voice></speak>"

Press Ctrl-X when you want to quite the editor and it will ask if you would like to save your changes.

There is a 'speech gallery' from [Microsoft](https://speech.microsoft.com/portal/voicegallery) here where you can see what voices are available, the one I chose is 'Cora'. If you pick a new voice you need its 'proper' name which includes a region, type etc. set as the 'name'.

You can also change the style, pitch and rate there's some rather verbose information [here](https://www.w3.org/TR/speech-synthesis/#S3.2.4). For the default MUTHUR voice we slowed and lowered the pitch of voice slightly which you can see under 'prosody'.

Note if you change the contents of 'muthur.py' it will be overwritten any time you use 'muthur/configure.sh' to change other settings. If you want to permanently swap to the the new voice, edit the template file with the following command. It's worth keeping a note of any changes you make for comparison.

```
nano muthur/muthurTemplate.py
```

## Looking after the Raspberry Pi

Your Raspberry Pi might be small but it is a proper computer and just yanking the power out of it while it's running may end up with it corrupting the SD card and stopping working.

Ideally you should log in to it and shut it down with the command 'sudo poweroff' then give it about 60s to cleanly shut down any time you are going to power it off.

Once you have the Pi working just how you like it can be set so the the files on the SD card become read-only with all changes being lost between uses. This helps prevent corruption of the SD card but may not completely prevent it.

Use the following command  to set the SD card into this read-only mode. This while take a while and the Raspberry Pi will reboot after you do this.

```
sudo raspi-config nonint do_overlayfs 0
```

Should you wish to enable changes again, for example to add another authorised user of the Telegram bot or to change which Wi-Fi network the Raspberry Pi connects to, use the following command.

```
sudo raspi-config nonint do_overlayfs 1
```

### Adding a shutdown button

To-Do
