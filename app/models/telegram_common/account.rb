class TelegramCommon::Account < ActiveRecord::Base
  unloadable

  belongs_to :user
  attr_accessible :user_id, :first_name, :last_name, :username, :active, :telegram_id
  validates :user_id, uniqueness: true, allow_nil: true

  before_save :set_token

  def name
    if username.present?
      "#{first_name} #{last_name} @#{username}"
    else
      "#{first_name} #{last_name}"
    end
  end

  def activate!
    update(active: true) unless active?
  end

  def deactivate!
    update(active: false) if active?
  end

  def old_trial?
    return false if last_try_at.blank?
    last_try_at < DateTime.now - 1.hour
  end

  def blocked?
    blocked_at.present? && blocked_at > DateTime.now - 1.hour
  end

  private

  def set_token
    self.token = SecureRandom.hex
  end
end
