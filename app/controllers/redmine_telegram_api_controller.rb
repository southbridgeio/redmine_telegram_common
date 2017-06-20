class RedmineTelegramApiController < ApplicationController
  unloadable

  layout false

  def authorize
    result = telegram.execute('Login',
      args: {
        phone_number: Setting.plugin_redmine_telegram_common['telegram_phone_number'],
        phone_code_hash: Setting.plugin_redmine_telegram_common['telegram_phone_code_hash'],
        phone_code: Setting.plugin_redmine_telegram_common['telegram_phone_code']
      }
    )

    telegram_auth_step = Setting.plugin_redmine_telegram_common['telegram_auth_step'].to_i

    if telegram_auth_step == 0
      phone_code_hash = JSON.parse(result)['phone_code_hash']

      fail if phone_code_hash.blank?

      Setting.plugin_redmine_telegram_common['telegram_phone_code_hash'] = phone_code_hash
      Setting.plugin_redmine_telegram_common['telegram_auth_step'] = 1
    elsif telegram_auth_step == 1
      reset_telegram_auth_step
    else
      fail("Undefined telegram auth step: #{telegram_auth_step}")
    end

    redirect_to plugin_settings_path('redmine_telegram_common'), notice: t('redmine_chat_telegram.authorize.success')
  rescue => e
    logger.fatal 'Failed to process API request'
    logger.fatal e.to_s
    logger.fatal result
    return redirect_to plugin_settings_path('redmine_telegram_common'), notice: t('redmine_chat_telegram.authorize.failed')
  end

  def auth_status
    result = telegram.execute('IsLogged')
    if result == 'true'
      redirect_to plugin_settings_path('redmine_telegram_common'), notice: t('redmine_chat_telegram.authorized')
    else
      redirect_to plugin_settings_path('redmine_telegram_common'), alert: t('redmine_chat_telegram.not_authorized')
    end
  end

  def deauthorize
    telegram.execute( 'Logout')
    redirect_to plugin_settings_path('redmine_telegram_common'), notice: t('redmine_chat_telegram.authorize.success')
  rescue
    redirect_to plugin_settings_path('redmine_telegram_common'), alert: t('redmine_chat_telegram.authorize.failed')
  end

  private

  def reset_telegram_auth_step
    Setting.plugin_redmine_telegram_common['telegram_auth_step'] = 0
    Setting.plugin_redmine_telegram_common['telegram_phone_code'] = nil
    Setting.plugin_redmine_telegram_common['telegram_phone_code_hash'] = nil
  end

  def telegram
    @telegram ||= TelegramCommon::Telegram.new
  end
end
