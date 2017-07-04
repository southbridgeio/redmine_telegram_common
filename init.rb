log_dir = Rails.root.join('log/telegram_common')

FileUtils.mkdir_p(log_dir) unless Dir.exist?(log_dir)

PHANTOMJS_CONFIG = File.expand_path('../config/phantom-proxy.js', __FILE__)
TELEGRAM_CLI_LOG = Logger.new(Rails.root.join(log_dir, 'telegram-cli.log'))

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
  version '0.1.2'
  url 'https://github.com/centosadmin/redmine_telegram_common'
  author 'Southbridge'
  author_url 'https://github.com/centosadmin'

  settings(default: {
      'phone_number' => ''
    },
    partial: 'settings/telegram_common')
end
