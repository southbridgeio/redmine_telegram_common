module TelegramCommon
  def self.table_name_prefix
    'telegram_common_'
  end

  def self.set_locale
    I18n.locale = Setting['default_language']
  end

  def self.bot_collisions?
    tokens = []
    if defined?(Intouch)
      tokens << Setting.plugin_redmine_intouch['telegram_bot_token']
    end
    if defined?(RedmineChatTelegram)
      tokens << Setting.plugin_redmine_chat_telegram['bot_token']
    end
    if defined?(Redmine2FA)
      tokens << Setting.plugin_redmine_2fa['bot_token']
    end
    tokens.compact!
    tokens.uniq.size != tokens.size
  end
end
