module TelegramCommon
  module BotCommand
    module Connect
      EMAIL_REGEXP = /([^@\s]+@(?:[-a-z0-9]+\.)+[a-z]{2,})/i

      def connect
        message_text = command.text.downcase
        email = message_text.scan(EMAIL_REGEXP)&.flatten&.first
        redmine_user = ::EmailAddress.find_by(address: email)&.user

        return user_not_found if redmine_user.nil?

        if account.user_id == redmine_user.id
          message = I18n.t('telegram_common.bot.connect.already_connected')
        else
          message = I18n.t('telegram_common.bot.connect.wait_for_email', email: email)

          TelegramCommon::Mailer.telegram_connect(redmine_user, account).deliver
        end

        send_message(message)
      end

      private

      def user_not_found
        increment_connect_trials
        if account.connect_trials_count < 3
          send_message(I18n.t('telegram_common.bot.connect.wrong_email'))
        else
          block_account
          send_blocked_message
        end
      end

      def increment_connect_trials
        account.connect_trials_count += 1
        account.save
      end

      def block_account
        account.blocked = true
        account.save
      end
    end
  end
end
