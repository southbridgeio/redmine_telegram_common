require 'telegram_common'

ActionDispatch::Callbacks.to_prepare do
  paths = '/lib/telegram_common/{patches/*_patch,hooks/*_hook}.rb'
  Dir.glob(File.dirname(__FILE__) + paths).each do |file|
    require_dependency file
  end
end

Redmine::Plugin.register :redmine_telegram_common do
  name 'Redmine Telegram Common plugin'
  description 'This is a plugin for other Redmine Telegram plugins'
  version '0.0.14'
  url 'https://github.com/centosadmin/redmine_telegram_common'
  author 'Centos-admin.ru'
  author_url 'https://centos-admin.ru'
end
