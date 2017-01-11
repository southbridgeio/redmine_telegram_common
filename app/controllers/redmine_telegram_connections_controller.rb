class RedmineTelegramConnectionsController < ApplicationController
  unloadable

  skip_before_filter :check_if_login_required, :check_password_change

  def create
    @user = User.find(params[:user_id])

    @telegram_account = TelegramCommon::Account.find_by(telegram_id: params[:telegram_id])

    connect_telegram_account_to_user

    redirect_to home_path, notice: notice
  end

  private

  def connect_telegram_account_to_user
    return unless @user.mail == params[:user_email] && params[:token] == @telegram_account.token

    old_telegram_account = TelegramCommon::Account.find_by(user_id: @user.id)
    old_telegram_account.destroy if old_telegram_account.present?

    @telegram_account.user = @user
    @telegram_account.save
  end

  def notice
    if @telegram_account.user.present?
      t('telegram_common.redmine_telegram_connections.create.success')
    else
      t('telegram_common.redmine_telegram_connections.create.error')
    end
  end
end
