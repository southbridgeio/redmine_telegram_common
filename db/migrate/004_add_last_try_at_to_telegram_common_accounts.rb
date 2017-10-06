class AddLastTryAtToTelegramCommonAccounts < ActiveRecord::Migration
  def change
    add_column :telegram_common_accounts, :last_try_at, :datetime
  end
end
