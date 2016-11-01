require File.expand_path('../../test_helper', __FILE__)

class RedmineTelegramConnectionsControllerTest < ActionController::TestCase
  fixtures :users, :email_addresses, :roles

  setup do
    @user = User.find(2)
    @telegram_account = TelegramCommon::Account.create(telegram_id: 123)
  end

  context 'connect with valid data' do
    setup do
      post :create,
           user_id: 2, user_email: @user.mail,
           telegram_id: 123, token: @telegram_account.token
    end

    should 'set telegram account to user' do
      @telegram_account.reload
      assert_equal @user, @telegram_account.user
    end
  end
end
