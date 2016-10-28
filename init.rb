require 'telegram'

ActionDispatch::Callbacks.to_prepare do
  paths = '/lib/telegram_common/{patches/*_patch,hooks/*_hook}.rb'
  Dir.glob(File.dirname(__FILE__) + paths).each do |file|
    require_dependency file
  end
end


Redmine::Plugin.register :redmine_telegram_common do
  name 'Redmine Telegram Common plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
