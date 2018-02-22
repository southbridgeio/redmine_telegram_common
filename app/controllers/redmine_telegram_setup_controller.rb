class RedmineTelegramSetupController < ApplicationController
  include TelegramCommon::Tdlib::DependencyProviders::Authenticate

  unloadable

  def step_1
  end

  def step_2
    begin
      authenticate.(params)
    rescue TelegramCommon::Tdlib::Authenticate::AuthenticationError => e
      redirect_to plugin_settings_path('redmine_telegram_common'), alert: e.message
    end
  end

  def authorize
    begin
      authenticate.(params)
      save_phone_settings(phone_number: params['phone_number'])
      redirect_to plugin_settings_path('redmine_telegram_common'), notice: t('telegram_common.client.authorize.success')
    rescue TelegramCommon::TdlibAuthenticate::AuthenticationError => e
      redirect_to plugin_settings_path('redmine_telegram_common'), alert: e.message
    end
  end

  def reset
    save_phone_settings(phone_number: nil)
    FileUtils.rm_rf(Rails.root.join('tmp', 'redmine_telegram_common', 'tdlib'))
    redirect_to plugin_settings_path('redmine_telegram_common')
  end

  def bot_init
    web_hook_url = "https://#{Setting.host_name}/telegram/api/web_hook"

    bot = TelegramCommon.init_bot
    bot.api.setWebhook(url: web_hook_url)

    redirect_to plugin_settings_path('redmine_telegram_common'), notice: t('redmine_chat_telegram.bot.authorize.success')
  end

  def bot_deinit
    token = Setting.plugin_redmine_telegram_common['bot_token']
    bot   = Telegram::Bot::Client.new(token)
    bot.api.setWebhook(url: '')
    redirect_to plugin_settings_path('redmine_telegram_common'), notice: t('redmine_chat_telegram.bot.deauthorize.success')
  end

  private

  def save_phone_settings(phone_number:)
    Setting.send('plugin_redmine_telegram_common=', Setting.plugin_redmine_telegram_common.merge({'phone_number' => phone_number.to_s}).to_h)
  end
end
