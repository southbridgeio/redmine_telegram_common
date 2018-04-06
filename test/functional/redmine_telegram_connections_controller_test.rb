require File.expand_path('../../test_helper', __FILE__)

class RedmineTelegramConnectionsControllerTest < ActionController::TestCase
  fixtures :users, :email_addresses, :roles

  setup do
    @user = users(:anonymous)
    @telegram_account = TelegramCommon::Account.create(telegram_id: 123)
  end

  context 'connect with valid data' do
    setup do
      @old_telegram_account = TelegramCommon::Account.create(telegram_id: 321, user_id: @user.id)
      post :create,
           user_id: @user.id, user_email: @user.mail,
           telegram_id: 123, token: @telegram_account.token
    end

    should 'destroy old telegram account' do
      assert_nil TelegramCommon::Account.find_by(telegram_id: 321)
    end

    should 'set telegram account to user' do
      @old_telegram_account.reload
      assert_equal @user, @old_telegram_account.user
      assert_equal 123, @old_telegram_account.telegram_id
    end
  end
end
