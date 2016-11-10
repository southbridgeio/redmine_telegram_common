class AddBlockedToTelegramCommonAccounts < ActiveRecord::Migration
  def change
    add_column :telegram_common_accounts, :blocked, :boolean, default: false, null: false
    add_column :telegram_common_accounts, :connect_trials_count, :integer, default: 0, null: false
  end
end
