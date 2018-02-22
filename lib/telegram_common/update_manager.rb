class TelegramCommon::UpdateManager
  def initialize
    @handlers = []
  end

  def add_handler(handler)
    @handlers << handler
  end

  def handle_message(message)
    @handlers.each { |handler| handler.call(message) }
  end
end
