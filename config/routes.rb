scope 'telegram' do
  get 'connect' => 'redmine_telegram_connections#create', as: 'telegram_connect'

  post 'authorize' => 'redmine_telegram_api#authorize', as: 'telegram_api_authorize'
  post 'auth_status' => 'redmine_telegram_api#auth_status', as: 'telegram_api_auth_status'
  delete 'deauthorize' => 'redmine_telegram_api#deauthorize', as: 'telegram_api_deauthorize'
end
