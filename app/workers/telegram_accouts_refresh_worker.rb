class TelegramAccountsRefreshWorker
  include Sidekiq::Worker
  include TelegramCommon::Tdlib::DependencyProviders::GetUser

  sidekiq_options queue: :telegram

  def perform
    TelegramCommon::Account.all.each do |account|
      user_data = get_user.(account.telegram_id)
      account.update_attributes(user_data.slice(%w[username first_name last_name]))
    end
  end
end
