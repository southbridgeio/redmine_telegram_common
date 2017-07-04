[![Build Status](https://travis-ci.org/centosadmin/redmine_telegram_common.svg?branch=master)](https://travis-ci.org/centosadmin/redmine_telegram_common)

# redmine_telegram_common

This is a common plugin for:
* [redmine_2fa](https://github.com/centosadmin/redmine_2fa)
* [redmine_intouch](https://github.com/centosadmin/redmine_intouch)
* [redmine_chat_telegram](https://github.com/centosadmin/redmine_chat_telegram)

This plugin includes
* PhantomJS script to make requests to modified Webogram (app/webogram), which makes requests to Telegram API
* `TelegramCommon::Account` model
* `TelegramCommon::Mailer`
* `TelegramCommon::Bot`
* `telegram_connect_url` helper

# Installation

* Ruby 2.2+
* Redmine 3.3+
* [PhantomJS](http://phantomjs.org)
* Standard install plugin:

```
cd {REDMINE_ROOT}
git clone https://github.com/centosadmin/redmine_telegram_common.git plugins/redmine_telegram_common
bundle install
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

### Upgrade to 0.1.0
 
Since version 0.1.0 this plugin use modified [Webogram](https://github.com/zhukov/webogram) instead Telegram CLI dependency. 
Please, take a look on new requirements and configuration.

## Plugin development

* Install Node.js
* Run `npm install -g gulp`
* Go to app/webogram
* Run `npm install`
* Run `gulp watch` and check page http://localhost:8000/app/index.html is opening

If you modify webogram, then you should:

* Go to app/webogram
* Remove assets/webogram if folder exists 
* Run `gulp publish`
* Add new files to repo
* Commit & push

## Telegram client settings

To make telegram client working you should follow steps:

* Be sure you set correct host in Redmine settings
* Go to the plugin settings page
* Press "Authorize Telegram client" button and follow instructions

Note: in production environment the plugin require serve static files via nginx or other similar solution (not same rails server), 
in development environment the plugin require running webogram from app/webogram directory (gulp watch).  

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

If plugin work in development environment, then content of the message will be duplicated at log/telegram_common/mailer

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

# Author of the Plugin

The plugin is designed by [Southbridge](https://southbridge.io)

