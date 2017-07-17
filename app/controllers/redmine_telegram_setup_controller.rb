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
    return redirect_to plugin_settings_path('redmine_telegram_common'), alert: t('telegram_common.client.authorize.failed')
  end

  def authorize
    result = telegram.execute('Login',
      args: {
        phone_number:     params['phone_number'],
        phone_code_hash:  params['phone_code_hash'],
        phone_code:       params['phone_code']
      }
    )

    if result == 'true'
      Setting.plugin_redmine_telegram_common['phone_number'] = params['phone_number']
      return redirect_to plugin_settings_path('redmine_telegram_common'), notice: t('telegram_common.client.authorize.success')
    else
      return redirect_to plugin_settings_path('redmine_telegram_common'), alert: t('telegram_common.client.authorize.failed')
    end

  rescue => e
    logger.fatal 'Failed to process API request'
    logger.fatal e.to_s
    logger.fatal result
    return redirect_to plugin_settings_path('redmine_telegram_common'), alert: t('telegram_common.client.authorize.failed')
  end

  def reset
    Setting.plugin_redmine_telegram_common['phone_number'] = nil
    telegram.reset
    redirect_to plugin_settings_path('redmine_telegram_common')
  end

  private

  def telegram
    @telegram ||= TelegramCommon::Telegram.new
  end
end
