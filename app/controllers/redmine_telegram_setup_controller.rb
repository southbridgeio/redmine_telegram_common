class RedmineTelegramSetupController < ApplicationController
  unloadable

  def step_1
  end

  def step_2
    result = telegram.execute('Login',
      args: {
          phone_number: params['phone_number']
      }
    )

    params[:phone_code_hash] = JSON.parse(result)['phone_code_hash']

    fail if params[:phone_code_hash].blank?
  rescue => e
    logger.fatal 'Failed to process API request'
    logger.fatal e.to_s
    logger.fatal result

    msg = t('telegram_common.client.authorize.failed')

    if e.class.to_s == 'TelegramCommon::Exceptions::Telegram'
      msg = "#{msg}: #{e.to_s}"
    end

    return redirect_to plugin_settings_path('redmine_telegram_common'), alert: msg
  end

  def authorize
    result = telegram.execute('Login',
      args: {
        phone_number:     params['phone_number'],
        phone_code_hash:  params['phone_code_hash'],
        phone_code:       params['phone_code']
      }
    )

    fail if result != 'true'

    save_phone_settings(phone_number: params['phone_number'])

    return redirect_to plugin_settings_path('redmine_telegram_common'), notice: t('telegram_common.client.authorize.success')

  rescue => e
    logger.fatal 'Failed to process API request'
    logger.fatal e.to_s
    logger.fatal result

    msg = t('telegram_common.client.authorize.failed')

    if e.class.to_s == 'TelegramCommon::Exceptions::Telegram'
      msg = "#{msg}: #{e.to_s}"
    end

    return redirect_to plugin_settings_path('redmine_telegram_common'), alert: msg
  end

  def reset
    save_phone_settings(phone_number: nil)
    telegram.reset
    redirect_to plugin_settings_path('redmine_telegram_common')
  end

  private

  def save_phone_settings(phone_number:)
    Setting.plugin_redmine_telegram_common['phone_number'] = phone_number
  end

  def telegram
    @telegram ||= TelegramCommon::Telegram.new
  end
end
