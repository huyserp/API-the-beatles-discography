Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :albums, only: [ :index, :show, :create, :update, :destroy ] do
        resources :sides, only: [ :create, :destroy ] do
          resources :tracks, only: [ :create, :update, :destroy ]
        end
      end
    end
  end
end
