module TelegramCommon
  module BotCommand
    module Connect
      EMAIL_REGEXP = /([^@\s]+@(?:[-a-z0-9]+\.)+[a-z]{2,})/i

      def connect
        message_text = command.text.downcase
        email = message_text.scan(EMAIL_REGEXP)&.flatten&.first
        redmine_user = ::EmailAddress.find_by(address: email)&.user

        if email.blank?
          send_message(I18n.t('telegram_common.bot.start.instruction_html'))
          return
        end

        logger.debug 'TelegramCommon::Bot#connect'
        logger.debug "message_text: #{message_text}"
        logger.debug "email: #{email}"
        logger.debug "redmine_user: #{redmine_user.inspect}"

        return user_not_found if redmine_user.nil?

        if account.user_id == redmine_user.id
          message = I18n.t('telegram_common.bot.connect.already_connected')
        else
          message = I18n.t('telegram_common.bot.connect.wait_for_email', email: email)

          TelegramCommon::Mailer.telegram_connect(redmine_user, account, plugin_name).deliver
        end

        send_message(message)
      end

      private

      def user_not_found
        increment_connect_trials
        if account.connect_trials_count < 3
          send_message(I18n.t('telegram_common.bot.connect.wrong_email', attempts: (3-account.connect_trials_count)))
        else
          block_account
          send_blocked_message
        end
      end

      def increment_connect_trials
        reset_trials if account.old_trial?
        account.connect_trials_count += 1
        account.last_try_at = DateTime.now
        account.save
      end

      def block_account
        account.blocked_at = DateTime.now
        reset_trials
        account.save
      end

      def reset_trials
        account.connect_trials_count = 0
      end
    end
  end
end
