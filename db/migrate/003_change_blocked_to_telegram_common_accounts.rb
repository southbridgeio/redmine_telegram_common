class ChangeBlockedToTelegramCommonAccounts < ActiveRecord::Migration
  def change
    remove_column :telegram_common_accounts, :blocked
    add_column :telegram_common_accounts, :blocked_at, :datetime
  end
end
