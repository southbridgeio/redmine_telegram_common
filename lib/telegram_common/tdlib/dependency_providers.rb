module TelegramCommon::Tdlib
  module DependencyProviders
    module Client
      def client
        settings = Setting.plugin_redmine_telegram_common
        TD::Api.set_log_file_path(Rails.root.join('log', 'telegram_common', 'tdlib.log').to_s)
        config = {
          api_id: settings['api_id'],
          api_hash: settings['api_hash'],
          database_directory: Rails.root.join('tmp', 'redmine_telegram_common', 'tdlib', 'db').to_s,
          files_directory: Rails.root.join('tmp', 'redmine_telegram_common', 'tdlib', 'files').to_s,
        }
        TD::Client.new(config)
      end
    end

    module Authenticate
      include Client

      def authenticate
        TelegramCommon::Tdlib::Authenticate.new(client, logger)
      end
    end

    module CreateChat
      include Client

      def create_chat
        TelegramCommon::Tdlib::CreateChat.new(client)
      end
    end

    module GetChatLink
      include Client

      def get_chat_link
        TelegramCommon::Tdlib::GetChatLink.new(client)
      end
    end

    module GetMe
      include Client

      def get_me
        TelegramCommon::Tdlib::GetMe.new(client)
      end
    end

    module CloseChat
      include Client

      def close_chat
        TelegramCommon::Tdlib::CloseChat.new(client)
      end
    end

    module RenameChat
      include Client

      def rename_chat
        TelegramCommon::Tdlib::RenameChat.new(client)
      end
    end

    module GetChat
      include Client

      def get_chat
        TelegramCommon::Tdlib::GetChat.new(client)
      end
    end

    module ToggleChatAdmin
      include Client

      def toggle_chat_admin
        TelegramCommon::Tdlib::ToggleChatAdmin.new(client)
      end
    end

    module AddBot
      include Client

      def add_bot
        TelegramCommon::Tdlib::AddBot.new(client)
      end
    end
  end
end
