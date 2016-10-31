[![Build Status](https://travis-ci.org/centosadmin/redmine_telegram_common.svg?branch=master)](https://travis-ci.org/centosadmin/redmine_telegram_common)

# redmine_telegram_common

This is a common plugin for:
* [redmine_2fa](https://github.com/centosadmin/redmine_2fa)
* [redmine_intouch](https://github.com/centosadmin/redmine_intouch)
* [redmine_chat_telegram](https://github.com/centosadmin/redmine_chat_telegram)

This plugin gets
* Telegram::Account model 
* `telegram_connect_url` helper

Plugin developed by [Centos-admin.ru](https://centos-admin.ru)

## Telegram::Account model

Table name: `telegram_common_accounts`

Telegram specific fields:
* `telegram_id` - integer with index
* `username` - string
* `first_name` - string
* `last_name` - string

Redmine specific fields:
* `user_id` - integer with index and foreign key
* `active` - boolean
* `token` - string (sets on `Telegram::Account` create)

Available methods:
* `name` - return concatenation of first_name, last_name and username (if it exists)
* `activate!`  - sets `active` to `true`
* `deactivate!`  - sets `active` to `false`

## `telegram_connect_url` helper

Required params
* `user_id` - redmine user id
* `user_email` - redmine user email
* `telegram_id` - `telegram_id` field form `Telegram::Account` record
* `token_id` - `token` field form `Telegram::Account` record

Plugin developed by [Centos-admin.ru](https://centos-admin.ru)
