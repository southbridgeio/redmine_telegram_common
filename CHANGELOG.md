# 0.0.14

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
