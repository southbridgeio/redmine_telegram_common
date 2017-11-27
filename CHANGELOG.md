# 0.1.4-dev

* Fix problem with telegram DC like AUTH_KEY_EMPTY

# 0.1.3

* Fixed bug with bot /connect command
* Add other AuthSources (like LDAP) support for 2fa
* Add last_try_at field to reset 2fa trials
* Ignore ssl errors for webogram
* Fix phone display
* Add Rails 5.1 support
* Fix mail from
* Add reset webogram cache method

# 0.1.2

* Update README
* Fix webogram setup

# 0.1.1

* Fix tests

# 0.1.0

* Add modified Webogram instead TelegramCLI
* Change license from MIT to GPL 3

# 0.0.15

* Replace ruby wrapper for Telegram's Bot API telegrammer to telegram-bot-ruby.

# 0.0.14

* Add validate uniq for telegram accounts.
* Change logic for command `/connect`.

# 0.0.13

* Add telegram_account info to view of user.
* Delete change auth_source after command connect.
* Add logic for unblock telegram account after 1 hour.
* Please run `bundle exec rake redmine:plugins:migrate NAME=redmine_telegram_common` after upgrade.

# 0.0.11

* Add `MessageSender` service class

# 0.0.9

* Notify when private command called from group chat

# 0.0.7

* Add `/help` command

# 0.0.6

* Add logic for block telegram account after 3 wrong `/connect` trials.
* Please run `bundle exec rake redmine:plugins:migrate NAME=redmine_telegram_common` after upgrade.
