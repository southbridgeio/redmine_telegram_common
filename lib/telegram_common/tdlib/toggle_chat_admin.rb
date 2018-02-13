module TelegramCommon::Tdlib
  class ToggleChatAdmin < Command
    def call(chat_id, user_id, admin = true)
      status = { '@type' => admin ? 'chatMemberStatusAdministrator' : 'chatMemberStatusMember' }
      @client.on_ready do |client|
        client.broadcast_and_receive('@type' => 'getUser', 'user_id' => user_id)
        client.broadcast_and_receive('@type' => 'setChatMemberStatus',
                                     'chat_id' => chat_id,
                                     'user_id' => user_id,
                                     'status' => status)
      end
    end
  end
end
