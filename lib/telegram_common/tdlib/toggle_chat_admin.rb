module TelegramCommon::Tdlib
  class ToggleChatAdmin < Command
    def call(chat_id, user_id, admin = true)
      status = { '@type' => admin ? 'chatMemberStatusAdministrator' : 'chatMemberStatusMember' }
      @client.on_ready do |client|
        client.broadcast_and_receive('@type' => 'setChatMemberStatus',
                                     'status' => status)
      end
    end
  end
end
