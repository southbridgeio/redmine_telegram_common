module TelegramCommon
  module BotCommand
    module Help
      def help
        message = private_command?(command) ? private_help_message : group_help_message
        send_message(command.chat.id, message)
      end

      private

      def private_command?(command)
        command.chat.type == 'private'
      end

      def private_commands
        %w(start connect help)
      end

      def group_commands
        []
      end

      def private_help_message
        help_command_list(private_commands)
      end

      def help_command_list(list, namespace: 'telegram_common', type: 'private')
        list.map do |command|
          %(/#{command} - #{I18n.t("#{namespace}.bot.#{type}.#{command}")})
        end.join("\n")
      end

      def group_help_message
        [I18n.t('telegram_common.bot.group'), private_help_message].join("\n")
      end
    end
  end
end
