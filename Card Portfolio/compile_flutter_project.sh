#!/bin/bash

CONFIG_CHATID=$chat_id
CONFIG_BOT_TOKEN=$token
BOT_MESSAGE_URL="https://api.telegram.org/bot$CONFIG_BOT_TOKEN/sendMessage"

install_flutter() {
    echo "Installing Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable
    export PATH="$PATH:`pwd`/flutter/bin"
    flutter doctor
}

check_flutter() {
    if ! command -v flutter &> /dev/null; then
        install_flutter
    else
        echo "Flutter is already installed."
    fi
}

upload_file() {
    local FILE="$1"
    RESPONSE=$(curl -T "$FILE" https://pixeldrain.com/api/file/)
    HASH=$(echo "$RESPONSE" | jq -r ".id")
    echo "https://pixeldrain.com/api/file/$HASH"
}

send_message() {
    local MESSAGE="$1"
    local CHAT_ID="$2"
    local RESPONSE=$(curl -s "$BOT_MESSAGE_URL" -d chat_id="$CHAT_ID" \
        -d "parse_mode=html" \
        -d "disable_web_page_preview=true" \
        -d text="$MESSAGE")
    local MESSAGE_ID=$(echo "$RESPONSE" | jq -r ".result.message_id")
    echo "$MESSAGE_ID"
}

compile_project() {
    flutter clean
    flutter pub get
    flutter build apk --release --target-platform android-arm64

    APK_DIR="build/app/outputs/apk/release/"
    for apk_file in "$APK_DIR"/*.apk; do
        echo "Uploading $apk_file ..."
        FILE_URL=$(upload_file "$apk_file")
        send_message "New APK uploaded: $FILE_URL" "$CONFIG_CHATID"
    done
}

main() {
    check_flutter
    compile_project
}

main