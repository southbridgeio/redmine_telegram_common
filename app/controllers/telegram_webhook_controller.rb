class TelegramWebhookController < ApplicationController
  def update
    TelegramHandlerWorker.perform_async(params)
    head :ok
  end
end
