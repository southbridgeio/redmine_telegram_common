require File.expand_path('../../../test_helper', __FILE__)

class TelegramCommon::AccountTest < ActiveSupport::TestCase
  def setup
    @telegram_account = TelegramCommon::Account.new first_name: 'John', last_name: 'Smith'
  end

  def test_name_without_username
    assert_equal 'John Smith', @telegram_account.name
  end

  def test_name_with_username
    @telegram_account.username = 'john_smith'
    assert_equal 'John Smith @john_smith', @telegram_account.name
  end

  def test_activate
    @telegram_account.update! active: false
    @telegram_account.activate!
    assert @telegram_account.active
  end

  def test_deactivate
    @telegram_account.update! active: true
    @telegram_account.deactivate!
    assert !@telegram_account.active
  end

  def test_blocked
    @telegram_account.blocked_at = DateTime.now
    @telegram_account.save
    assert @telegram_account.blocked?

    @telegram_account.blocked_at = DateTime.now - 2.hour
    @telegram_account.save
    assert !@telegram_account.blocked?
  end
end
