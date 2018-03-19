scope 'telegram' do
  get 'connect' => 'redmine_telegram_connections#create', as: 'telegram_connect'

  scope :setup do
    get 'step_1' => 'redmine_telegram_setup#step_1', as: :telegram_setup_1
    post 'step_2' => 'redmine_telegram_setup#step_2', as: :telegram_setup_2
    post 'authorize' => 'redmine_telegram_setup#authorize', as: :telegram_setup_authorize
    delete 'reset' => 'redmine_telegram_setup#reset', as: :telegram_setup_reset
  end

  scope :api do
    post 'web_hook', to: TelegramWebhookController.action(:update), as: 'telegram_common_webhook'
    post 'bot_init' => 'redmine_telegram_setup#bot_init', as: 'telegram_common_bot_init'
    delete 'bot_deinit' => 'redmine_telegram_setup#bot_deinit', as: 'telegram_common_bot_deinit'
  end

  get 'login' => 'telegram_login#index', as: 'telegram_login'
  get 'check_auth' => 'telegram_login#check_auth'
end
