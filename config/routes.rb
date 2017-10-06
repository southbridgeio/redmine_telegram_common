scope 'telegram' do
  get 'connect' => 'redmine_telegram_connections#create', as: 'telegram_connect'

  scope :setup do
    get 'step_1' => 'redmine_telegram_setup#step_1', as: :telegram_setup_1
    post 'step_2' => 'redmine_telegram_setup#step_2', as: :telegram_setup_2
    post 'authorize' => 'redmine_telegram_setup#authorize', as: :telegram_setup_authorize
    delete 'reset' => 'redmine_telegram_setup#reset', as: :telegram_setup_reset
  end
end
