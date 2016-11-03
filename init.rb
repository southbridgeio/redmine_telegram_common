Redmine::Plugin.register :redmine_telegram_common do
  name 'Redmine Telegram Common plugin'
  description 'This is a plugin for other Redmine Telegram plugins'
  version '0.1.0'
  url 'https://github.com/centosadmin/redmine_telegram_common'
  author 'Centos-admin.ru'
  author_url 'https://centos-admin.ru'
end

ActionDispatch::Callbacks.to_prepare do
  require 'telegram_common'
  %w( /app/models/telegram_common/*.rb
      /lib/telegram_common/{patches/*_patch,hooks/*_hook}.rb).each do |paths|
    Dir.glob(File.dirname(__FILE__) + paths).each do |file|
      require_dependency file
    end
  end
end
