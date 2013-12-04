PushServer::Application.routes.draw do
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]

  resources :users

  resources :devices do
    resources :messages
    post 'send_message', on: :member
  end

  resources :clients do
    resources :messages
  end

  get '/messages' => 'messages#list'
  get '/logout'   => 'sessions#destroy'

  root to: 'users#index'

  namespace :api do
    get  'sender_id', to: 'devices#sender_id'
    post 'messages', to: 'messages#send_message'
    post 'devices/register'
    post 'devices/:device_name/messages', to: 'devices#send_message'
  end
end
