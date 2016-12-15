module TelegramCommon
  class Bot
    class MessageSender
      def self.call(params)
        new(params).call
      end

      attr_reader :chat_id, :message, :bot_token, :params

      def initialize(params)
        @message = params.fetch(:message)
        @chat_id = params.fetch(:chat_id)
        @bot_token = params.fetch(:bot_token)
        @params = params.except(:message, :chat_id, :bot_token)
      end

      def call
        message_params = {
          chat_id: chat_id,
          text: message,
          parse_mode: 'HTML',
          disable_web_page_preview: true,
        }.merge(params)

        bot.send_message(message_params)
      end

      private

      def bot
        @bot ||= Telegrammer::Bot.new(bot_token)
      end
    end
  end
end
