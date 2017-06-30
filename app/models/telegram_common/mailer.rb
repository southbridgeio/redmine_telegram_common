class TelegramCommon::Mailer < ActionMailer::Base
  layout 'mailer'
  helper :application
  helper :issues
  helper :custom_fields

  include Redmine::I18n

  default from: "#{Setting.app_title} <#{Setting.mail_from}>" unless Rails.env.test?

  def self.default_url_options
    ::Mailer.default_url_options
  end

  def telegram_connect(user, telegram_account, plugin_name)
    TelegramCommon.set_locale
    @user = user
    @telegram_account = telegram_account
    @plugin_name = plugin_name

    logger.debug 'TelegramCommon::Mailer.telegram_connect'
    logger.debug "user: #{user.inspect}"
    logger.debug "telegram_account: #{telegram_account.inspect}"
    logger.debug "plugin_name: #{plugin_name}"

    mail = mail(to: @user.mail,
         subject: I18n.t('telegram_common.mailer.telegram_connect.subject'),
         template_path: 'telegram_common/mailer')

    logger.debug mail.body.encoded if Rails.env.development? && mail
  end

  private

  def logger
    @logger ||= Logger.new(Rails.root.join('log/telegram_common', 'mailer.log'))
  end
end
