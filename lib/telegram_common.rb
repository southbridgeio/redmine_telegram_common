module TelegramCommon
  def self.table_name_prefix
    'telegram_common_'
  end

  def self.set_locale
    I18n.locale = Setting['default_language']
  end
end
