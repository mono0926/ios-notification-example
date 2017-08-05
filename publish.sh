#!/bin/bash
curl -v \
-d '{ "aps": { "alert": "message", "badge":1 }}' \
-H "apns-topic: com.mono0926.notification.example" \
-H "apns-priority: 10" \
-H "authorization: bearer YOUR_NOTIFICATION_TOKEN" \
--http2 \
https://api.development.push.apple.com/3/device/YOUR_DEVICE_TOKEN
# Production版のアプリに送る時は、下記のエンドポイント(運用によるが常に両方に送るのもあり)
# https://api.push.apple.com
