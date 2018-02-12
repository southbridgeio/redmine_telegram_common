module TelegramCommon::Tdlib
  class CloseChat < Command
    def call(chat_id)
      @client.on_ready do |client|
        chat = client.broadcast_and_receive('@type' => 'getChat', 'chat_id' => chat_id)
        supergroup_id = chat.dig('type', 'supergroup_id')
        client.broadcast_and_receive('@type' => 'deleteSupergroup', 'supergroup_id' => supergroup_id)
      end
    end
  end
end
