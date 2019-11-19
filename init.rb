log_dir = Rails.root.join('log/telegram_common')

FileUtils.mkdir_p(log_dir) unless Dir.exist?(log_dir)

require 'telegram/bot'

# Rails 5.1/Rails 4
reloader = defined?(ActiveSupport::Reloader) ? ActiveSupport::Reloader : ActionDispatch::Reloader
reloader.to_prepare do
  require_dependency 'telegram_common'

  paths = '/lib/telegram_common/{patches/*_patch,hooks/*_hook}.rb'
  Dir.glob(File.dirname(__FILE__) + paths).each do |file|
    require_dependency file
  end

  Faraday::Adapter.register_middleware redmine_telegram_common: TelegramCommon::Bot::FaradayAdapter

  Telegram::Bot.configure do |config|
    config.adapter = :redmine_telegram_common
  end
end

Rails.application.config.eager_load_paths += Dir.glob("#{Rails.application.config.root}/plugins/redmine_telegram_common/{lib,app/workers,app/models,app/controllers}")

Sidekiq::Logging.logger = Logger.new(Rails.root.join('log', 'sidekiq.log'))

Sidekiq::Cron::Job.create(name:  'Update telegram accounts info',
                          cron:  '0 2 * * *',
                          class: 'TelegramAccountsRefreshWorker')

Redmine::Plugin.register :redmine_telegram_common do
  name 'Redmine Telegram Common plugin'
  description 'This is a plugin for other Redmine Telegram plugins'
  version '0.7.2'
  url 'https://github.com/southbridgeio/redmine_telegram_common'
  author 'Southbridge'
  author_url 'https://github.com/southbridgeio'

  settings(default: {
      'phone_number' => '',
      'api_id' => '',
      'api_hash' => '',
      'bot_token' => '',
      'bot_name' => '',
      'bot_id' => '',
      'robot_id' => ''
    },
    partial: 'settings/telegram_common')
end
