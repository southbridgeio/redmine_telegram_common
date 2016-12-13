module TelegramCommon
  class Bot
    class MessageSender
      def self.call(params)
        new(params).call
      end

      attr_reader :chat_id, :message, :bot_token

      def initialize(message:, chat_id:, bot_token:)
        @message = message
        @chat_id = chat_id
        @bot_token = bot_token
      end

      def call
        bot.send_message(chat_id: chat_id, text: message, parse_mode: 'HTML')
      end

      private

      def bot
        @bot ||= Telegrammer::Bot.new(bot_token)
      end
    end
  end
end
