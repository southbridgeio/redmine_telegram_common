module TelegramCommon::Tdlib
  class CloseChat < Command
    def call(chat_id)
      @client.on_ready do |client|
        chat = client.broadcast_and_receive('@type' => 'getChat', 'chat_id' => chat_id)

        client.broadcast_and_receive('@type' => 'getBasicGroupFullInfo',
                                     'basic_group_id' => chat.dig('type', 'basic_group_id')
        )['members'].map { |m| m['user_id'] }.each do |user_id|
          client.broadcast_and_receive('@type' => 'setChatMemberStatus',
                                      'chat_id' => chat_id,
                                      'user_id' => user_id,
                                      'status' => { '@type' => 'chatMemberStatusLeft' })
        end
      end
    end
  end
end
