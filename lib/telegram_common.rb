module TelegramCommon
  def self.table_name_prefix
    'telegram_common_'
  end

  def self.set_locale
    I18n.locale = Setting['default_language']
  end

  def self.bot_collisions
    tokens = {}
    if defined?(Intouch)
      tokens[:redmine_intouch] = Setting.plugin_redmine_intouch['telegram_bot_token']
    end
    if defined?(RedmineChatTelegram)
      tokens[:redmine_chat_telegram] = Setting.plugin_redmine_chat_telegram['bot_token']
    end
    if defined?(Redmine2FA)
      tokens[:redmine_2fa] = Setting.plugin_redmine_2fa['bot_token']
    end
    tokens.delete_if { |_, v| v.nil? }
    token_values = tokens.values
    duplicates = token_values.uniq.map { |e| [token_values.count(e), e] }.select { |c, _| c > 1 }.map { |_, e| e }
    duplicates.map { |token| tokens.select { |k, v| v == token }.keys }
  end
end
