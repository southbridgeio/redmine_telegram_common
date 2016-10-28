scope 'telegram' do
  get 'connect' => 'redmine_telegram_connections#create', as: 'telegram_connect'
end
