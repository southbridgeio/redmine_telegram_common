module TelegramCommon::Tdlib
  class CreateChat < Command
    def call(title, user_ids)
      @client.on_ready do |client|
        user_ids.each do |id|
          client.broadcast_and_receive('@type' => 'getUser', 'user_id' => id)
        end

        chat = client.broadcast_and_receive('@type' => 'createNewSupergroupChat',
                                    'title' => title)

        user_ids.each do |id|
          client.broadcast_and_receive('@type' => 'addChatMember',
                                       'chat_id' => chat['id'],
                                       'user_id' => id)
        end
        chat
      end
    end
  end
end
