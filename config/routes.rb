Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  namespace :api do
    resources :inventory_storages, only: [:create]
  end

  # config/routes.rb
  Rails.application.routes.draw do
    resources :locations do
      member do
        get :new_file, to: 'locations#new_file_upload'
        post :upload_csv, to: 'locations#upload_customer_csv'
        post :generate_report, to: 'locations#generate_report'
      end
    end
  end


end
