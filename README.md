[![Build Status](https://travis-ci.org/centosadmin/redmine_telegram_common.svg?branch=master)](https://travis-ci.org/centosadmin/redmine_telegram_common)

# redmine_telegram_common

This is a common plugin for:
* [redmine_2fa](https://github.com/centosadmin/redmine_2fa)
* [redmine_intouch](https://github.com/centosadmin/redmine_intouch)
* [redmine_chat_telegram](https://github.com/centosadmin/redmine_chat_telegram)

This plugin includes
* `TelegramCommon::Account` model
* `TelegramCommon::Mailer`
* `TelegramCommon::Bot`
* `telegram_connect_url` helper

Plugin is developed by [Centos-admin.ru](https://centos-admin.ru)

## TelegramCommon::Account model

Table name: `telegram_common_accounts`

Telegram specific fields:
* `telegram_id` - integer with index
* `username` - string
* `first_name` - string
* `last_name` - string

Redmine specific fields:
* `user_id` - integer with index and foreign key
* `active` - boolean
* `token` - string (sets on `TelegramCommon::Account` create)

Available methods:
* `name` - return concatenation of first_name, last_name and username (if it exists)
* `activate!`  - sets `active` to `true`
* `deactivate!`  - sets `active` to `false`

## TelegramCommon::Mailer

This mailer has one method `telegram_connect(user, telegram_account)`, where
* `user` - Redmine user
* `telegram_account` - `TelegramCommon::Account` instance

## TelegramCommon::Bot

This is a service object which handle two bot commands:
* `/start`
* `/connect account@redmine.com`

For connect telegram account to redmine account user needs to add a bot with `/start` command.

After that the bot prompts to enter the command `/connect account@redmine.com`.

After the command, the user will receive an email with a link.

Following the link will connect the user's accounts and he will be able to receive one-time passwords from the bot.

### Example of bot usage

```ruby
TelegramCommon::Bot.new(bot_token, message, logger).call
```

* bot_token - bot token from yor plugin
* message - message from telegram webhook `params[:message]` or `Telegram::Bot::Types::Message` instance
* logger - optional field, `Logger` instance

Real usage example: [BotWebhookController](https://github.com/centosadmin/redmine_2fa/blob/master/app/controllers/otp_bot_webhook_controller.rb)

## `telegram_connect_url` helper

Required params
* `user_id` - redmine user id
* `user_email` - redmine user email
* `telegram_id` - `telegram_id` field form `TelegramCommon::Account` record
* `token_id` - `token` field form `TelegramCommon::Account` record

Plugin is developed by [Centos-admin.ru](https://centos-admin.ru)
