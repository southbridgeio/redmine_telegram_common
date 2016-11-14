require 'telegrammer'

module TelegramCommon
  class Bot
    EMAIL_REGEXP = /([^@\s]+@(?:[-a-z0-9]+\.)+[a-z]{2,})/i

    attr_reader :bot, :logger, :command

    def initialize(bot_token, command, logger = nil)
      @bot = Telegrammer::Bot.new(bot_token)
      @logger = logger
      @command = command.is_a?(Telegrammer::DataTypes::Message) ? command : Telegrammer::DataTypes::Message.new(command)
    end

    def call
      TelegramCommon.set_locale

      return send_blocked_message if account.blocked?

      command_text = command.text

      if command_text&.include?('start')
        start
      elsif command_text&.include?('/connect')
        connect
      end
    end

    def start
      update_account

      update_auth_source if Redmine::Plugin.installed?('redmine_2fa')

      message = if account.user.present?
                  I18n.t('telegram_common.bot.start.hello')
                else
                  I18n.t('telegram_common.bot.start.instruction_html')
                end

      send_message(command.chat.id, message)
    end

    def connect
      message_text = command.text
      email = message_text.scan(EMAIL_REGEXP)&.flatten&.first
      redmine_user = EmailAddress.find_by(address: email)&.user

      return user_not_found if redmine_user.nil?

      if account.user_id == redmine_user.id
        message = I18n.t('telegram_common.bot.connect.already_connected')
      else
        message = I18n.t('telegram_common.bot.connect.wait_for_email', email: email)

        TelegramCommon::Mailer.telegram_connect(redmine_user, account).deliver
      end

      send_message(command.chat.id, message)
    end

    private

    def user_not_found
      increment_connect_trials
      if account.connect_trials_count < 3
        send_message(command.chat.id, I18n.t('telegram_common.bot.connect.wrong_email'))
      else
        block_account
        send_blocked_message
      end
    end

    def send_blocked_message
      send_message(command.chat.id, I18n.t('telegram_common.bot.connect.blocked'))
    end

    def increment_connect_trials
      account.connect_trials_count += 1
      account.save
    end

    def block_account
      account.blocked = true
      account.save
    end

    def user
      command.from
    end

    def account
      @account ||= fetch_account
    end

    def fetch_account
      Account.where(telegram_id: user.id).first_or_initialize
    end

    def update_account
      account.assign_attributes username: user.username,
                                first_name: user.first_name,
                                last_name: user.last_name,
                                active: true

      write_log_about_new_user if @logger && account.new_record?

      account.save!
    end

    def update_auth_source
      return unless account.user.present? && account.user.auth_source.nil?
      account.user.update auth_source_id: ::Redmine2FA::AuthSource::Telegram.first&.id
    end

    def send_message(chat_id, message)
      bot.send_message(chat_id: chat_id, text: message, parse_mode: 'HTML')
    end

    def write_log_about_new_user
      @logger.info "New telegram_user #{user.first_name} #{user.last_name} @#{user.username} added!"
    end
  end
end
