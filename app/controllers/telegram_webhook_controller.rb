class TelegramWebhookController < ApplicationController
  TYPES = %w(inline_query
                chosen_inline_result
                callback_query
                edited_message
                message
                channel_post
                edited_channel_post)

  def update
    update = Telegram::Bot::Types::Update.new(params)
    message = TYPES.reduce { |m, t| m || update.public_send(t) }
    TelegramCommon.update_manager.handle_message(message)

    head :ok
  end
end
