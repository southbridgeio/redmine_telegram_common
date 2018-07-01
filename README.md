[![Build Status](https://travis-ci.org/centosadmin/redmine_telegram_common.svg?branch=master)](https://travis-ci.org/centosadmin/redmine_telegram_common)
[![Rate at redmine.org](http://img.shields.io/badge/rate%20at-redmine.org-blue.svg?style=flat)](http://www.redmine.org/plugins/redmine_telegram_common)

# redmine_telegram_common

This is a common plugin for:
* [redmine_2fa](https://github.com/centosadmin/redmine_2fa)
* [redmine_intouch](https://github.com/centosadmin/redmine_intouch)
* [redmine_chat_telegram](https://github.com/centosadmin/redmine_chat_telegram)

This plugin includes

* `TelegramCommon::Account` model
* `TelegramCommon::Mailer`
* `TelegramCommon::Bot`
* `TelegramCommon::Tdlib`
* `telegram_connect_url` helper

# Installation

* Ruby 2.3+
* Redmine 3.3+
* [redmine_sidekiq](https://github.com/centosadmin/redmine_sidekiq)
* *Compiled [TDLib](https://github.com/tdlib/td)*:

  You should place it in `redmine_root/vendor` or add it to [ldconfig](https://www.systutorials.com/docs/linux/man/8-ldconfig/).

  For CentOS you can use our repositories:

  http://rpms.southbridge.ru/rhel7/stable/x86_64/

  http://rpms.southbridge.ru/rhel6/stable/x86_64/

  And also SRPMS:

  http://rpms.southbridge.ru/rhel7/stable/SRPMS/

  http://rpms.southbridge.ru/rhel6/stable/SRPMS/

* Obtain your api_id and api_hash from [this page](https://my.telegram.org/apps). Then you should set it on the plugin settings page.

* Standard install plugin:

```
cd {REDMINE_ROOT}
git clone https://github.com/centosadmin/redmine_telegram_common.git plugins/redmine_telegram_common
bundle install
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

## Telegram client settings

To make telegram client working you should follow steps:

* Be sure you set correct host in Redmine settings
* Go to the plugin settings page
* Press "Authorize Telegram client" button and follow instructions

### Create Telegram Bot

It is necessary to register a bot and get its token.
There is a [@BotFather](https://telegram.me/botfather) bot used in Telegram for this purpose.
Type `/start` to get a complete list of available commands.

Type `/newbot` command to register a new bot.
[@BotFather](https://telegram.me/botfather) will ask you to name the new bot. The bot's name must end with the "bot" word.
On success @BotFather will give you a token for your new bot and a link so you could quickly add the bot to the contact list.
You'll have to come up with a new name if registration fails.

Set the Privacy mode to disabled with `/setprivacy`. This will let the bot listen to all group chats and write its logs to Redmine chat archive.

Set bot domain with `/setdomain` for account connection via Telegram Login. Otherwise, you will receive `Bot domain invalid` error on account connection page.

Enter the bot's token on the Plugin Settings page to add the bot to your chat.

To add hints for commands for the bot, use command `/setcommands`. You need to send list of commands with descriptions. You can get this list from command `/help`.

### Bot modes

Bot can work in two [modes](https://core.telegram.org/bots/api#getting-updates) — getUpdates or WebHooks.

#### getUpdates

To work via getUpdates, you should run bot process `bundle exec rake telegram_common:bot`.
This will drop bot WebHook setting.

#### WebHooks

To work via WebHooks, you should go to plugin settings and press button "Initialize bot"
(bot token should be saved earlier, and notice that redmine should work on https)

### Add bot to user contacts

Type `/start` command to your bot from your user account.
This allows the user to add a Bot to group chats.

Also, bot should be added to contacts of account used to authorize telegram client in plugin.

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

## TelegramCommon::Bot

This is a service object which handle two bot commands:
* `/start`
* `/connect`

For connect telegram account to redmine account user needs to add a bot with `/start` command.

After that the bot prompts to enter the command `/connect`.

After the command, the user will message with link to connection page (uses Telegram Login widget)

### Example of bot usage

```ruby
TelegramCommon::Bot.new(bot_token, message, logger).call
```

* bot_token - bot token from yor plugin
* message - message from telegram webhook `params[:message]` or `Telegram::Bot::Types::Message` instance
* logger - optional field, `Logger` instance

Real usage example: [BotWebhookController](https://github.com/centosadmin/redmine_2fa/blob/master/app/controllers/otp_bot_webhook_controller.rb)

# Author of the Plugin

The plugin is designed by [Southbridge](https://southbridge.io)
