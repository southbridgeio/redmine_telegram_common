require 'telegrammer'

module TelegramCommon
  class Bot
    include BotCommand::Start
    include BotCommand::Connect
    include BotCommand::Help

    attr_reader :bot, :logger, :command

    def initialize(bot_token, command, logger = nil)
      @bot = Telegrammer::Bot.new(bot_token)
      @logger = logger
      @command = command.is_a?(Telegrammer::DataTypes::Message) ? command : Telegrammer::DataTypes::Message.new(command)
    end

    def call
      TelegramCommon.set_locale

      return send_blocked_message if account.blocked?

      execute_command
    end

    private

    def available_commands
      (private_commands + group_commands).uniq
    end

    def execute_command
      command_text = command.text

      command_name = command_text.scan(%r{^/(\w+)}).flatten.first

      send(command_name) if available_commands.include?(command_name)
    end

    def send_message(chat_id, message)
      bot.send_message(chat_id: chat_id, text: message, parse_mode: 'HTML')
    end

    def send_blocked_message
      send_message(command.chat.id, I18n.t('telegram_common.bot.connect.blocked'))
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
  end
end
