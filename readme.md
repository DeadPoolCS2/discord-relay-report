<div align="center">
    <h1>Discord Relay&Report</h1>
</div>

<div align="center">Discord Relay&Report is a simple plugin designed for syncing the chat on your CS2 Server and also includes a report function.
</div>




## Features

- Sync Server Chat via Discord Webhook
- Report Function via Discord Webhook
- Custom Config via the `configs/discord-relay-report/config.json`

## Requirements 📋

1. [Metamod 2.X](https://www.metamod.org)
2. [Swiftly](https://github.com/swiftly-solution/swiftly/)

## Installation

1. Download and install Metamod 2.X.
2. Download and install Swiftly.
3. Download the Discord Relay&Report Plugin from the [releases page](https://github.com/imp87/discord-relay-report).
4. Extract the files into `addons/swiftly`

## Configuration
Edit the JSON configuration file
`addons/swiftly/configs/plugins/discord-relay-report/config.json`
with your configuration
```
{
    "enableChatsync": true,
    "enableReport": true,
    "webhookChatync": "",
    "webhookReport": "",
    "imageReport": "",
    "discordMessage": "We just received a new report of a suspect"
}
```

## Configuration Parameters
- `enableChatsync:` Set to true to enable chat synchronization via Discord webhook. Set to false to disable it.
- `enableReport:` Set to true to enable the report functionality via Discord webhook. Set to false to disable it.
- `webhookChatync:` The URL of the Discord webhook where chat messages will be sent.
- `webhookReport:` The URL of the Discord webhook where player reports will be sent.
- `imageReport:` (Optional) The URL of an image to include in the report messages.
- `discordMessage:` The default message content for the report notifications.

## Special Thanks

✦ Special thanks to [@skuzzis](https://github.com/skuzzis) for helping me

## Contributors

Made by [imp87](https://github.com/imp87)

[![Contributors](https://img.shields.io/github/contributors/imp87/discord-relay-report)](https://github.com/imp87/discord-relay-report/graphs/contributors)

