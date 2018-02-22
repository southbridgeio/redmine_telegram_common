def init_bot
  Process.daemon(true, true) if Rails.env.production?

  tries = 0
  begin
    tries += 1

    if ENV['PID_DIR']
      pid_dir = ENV['PID_DIR']
      PidFile.new(piddir: pid_dir, pidfile: 'telegram-chat-bot.pid')
    else
      PidFile.new(piddir: Rails.root.join('tmp', 'pids'), pidfile: 'telegram-chat-bot.pid')
    end

  rescue PidFile::DuplicateProcessError => e
    LOG.error "#{e.class}: #{e.message}"
    pid = e.message.match(/Process \(.+ - (\d+)\) is already running./)[1].to_i

    LOG.info "Kill process with pid: #{pid}"

    Process.kill('HUP', pid)
    if tries < 4
      LOG.info 'Waiting for 5 seconds...'
      sleep 5
      LOG.info 'Retry...'
      retry
    end
  end

  Signal.trap('TERM') do
    at_exit { LOG.error 'Aborted with TERM signal' }
    abort
  end

  LOG.info 'Start daemon...'

  token = Setting.plugin_redmine_telegram_common['bot_token']

  unless token.present?
    LOG.error 'Telegram Bot Token not found. Please set it in the plugin config web-interface.'
    exit
  end

  LOG.info 'Telegram Bot: Connecting to telegram...'

  require 'telegram/bot'

  bot = TelegramCommon.init_bot
  bot.api.setWebhook(url: '') # reset webhook
  bot
end

namespace :telegram_common do
  # bundle exec rake telegram_common:bot PID_DIR='tmp/pids'
  desc "Runs telegram bot process (options: default PID_DIR='tmp/pids')"
  task bot: :environment do
    LOG = Rails.env.production? ? Logger.new(Rails.root.join('log/telegram_common', 'bot.log')) : Logger.new(STDOUT)

    bot = init_bot
    begin
      bot.listen do |message|
        next unless message.is_a?(Telegram::Bot::Types::Message)
        TelegramCommon.update_manager.handle_message(message)
      end
    rescue => e
      ExceptionNotifier.notify_exception(e) if defined?(ExceptionNotifier)
      LOG.error "GLOBAL #{e.class}: #{e.message}\n#{e.backtrace.join("\n")}"
    end
  end
end