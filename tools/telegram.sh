#!/bin/sh

# Telegram functions for OF building scripts

# Get Telegram Bot API id
get_telegram_keys() {
	IFS="
"
	if [ -f telegram_api.txt ]; then
		for i in $(cat telegram_api.txt); do
			if [ "$(printf '%s' "$i" | cut -c1)" != "#" ]; then
				export $i
			fi
		done
		IFS=" "
	else
		echo "Telegram API values not found!"
		IFS=" "
		exit
	fi
}

send_message() {
	export MESSAGE_ID=$(curl -s -X POST "https://api.telegram.org/bot$TG_BOT_TOKEN/sendMessage" -d chat_id=$TG_CHAT_ID -d text="$1" | jq -r '.result.message_id')
}

edit_message() {
	curl -s -X POST "https://api.telegram.org/bot$TG_BOT_TOKEN/editMessageText" -d chat_id=$TG_CHAT_ID -d message_id=$MESSAGE_ID -d text="$1" > /dev/null
}

send_file() {
	curl -F name=document -F document=@"$1" -H "Content-Type:multipart/form-data" "https://api.telegram.org/bot$TG_BOT_TOKEN/sendDocument?chat_id=$TG_CHAT_ID" > /dev/null
}
