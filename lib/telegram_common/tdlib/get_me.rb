module TelegramCommon::Tdlib
  class GetMe < Command
    def call
      @client.on_ready do |client|
        client.broadcast_and_receive('@type' => 'getMe')
      end
    end
  end
end
