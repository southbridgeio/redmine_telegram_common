module RedmineTelegramCommon
  module Hooks
    class UserFormHook < Redmine::Hook::ViewListener
      render_on :view_users_form, :partial => "telegram_common/users/telegram_account", :user => @user
      render_on :view_my_account, :partial => "telegram_common/users/telegram_account", :user => @user
    end
  end
end
