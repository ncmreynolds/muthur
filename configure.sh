#!/usr/bin/bash
#
# This naive configuration script just uses sed to edit the configuration of muthur
#

#Ask for all the necessary configuration

read -p "What is your Telegram bot API token: " telegram_token
read -p "What is your Telegram bot allowed user list: " telegram_users
read -p "What is your Azure speech API key: " azure_key
read -p "What is your Azure speech service region: " azure_region

#Copy the template script
cp ~/muthur/muthurTemplate.py ~/muthur/muthur.py

#Update the tokens in the muthur Python script with sed
sed -i "s/TELEGRAMTOKEN/$telegram_token/g" ~/muthur/muthur.py
sed -i "s/ALLOWEDUSERS/$telegram_users/g" ~/muthur/muthur.py
sed -i "s/SPEECHKEY/$azure_key/g" ~/muthur/muthur.py
sed -i "s/SERVICEREGION/$azure_region/g" ~/muthur/muthur.py

#Install and start the service
sudo cp ~/muthur/muthur.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable muthur
sudo systemctl start muthur
sudo systemctl status muthur