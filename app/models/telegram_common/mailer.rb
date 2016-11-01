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

  def telegram_connect(user, telegram_account)
    TelegramCommon.set_locale
    @user = user
    @telegram_account = telegram_account

    mail to: @user.mail,
         subject: I18n.t('telegram_common.mailer.telegram_connect.subject'),
         template_path: 'telegram_common/mailer'
  end
end
