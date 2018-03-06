module TelegramCommon
  module BotCommand
    module Connect
      EMAIL_REGEXP = /([^@\s]+@(?:[-a-z0-9]+\.)+[a-z]{2,})/i

      def connect
        message_text = command.text.downcase
        redmine_user = account&.user

        logger.debug 'TelegramCommon::Bot#connect'
        logger.debug "message_text: #{message_text}"
        logger.debug "redmine_user: #{redmine_user.inspect}"

        if redmine_user.present?
          message = I18n.t('telegram_common.bot.connect.already_connected')
        else
          message = I18n.t('telegram_common.bot.connect.login_link', link: "#{Setting.protocol}://#{Setting.host_name}/telegram/login")
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
