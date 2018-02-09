module TelegramCommon
  def self.table_name_prefix
    'telegram_common_'
  end

  def self.set_locale
    I18n.locale = Setting['default_language']
  end

  module_function

  def redmine_host_valid?
    Setting.host_name.split(':').first != 'localhost'
  end

  def rails_env_valid?
    Rails.env.production?
  end
end
