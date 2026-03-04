Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v2 do
      post "login", to: "auth#login"

      resource :balance, only: [:show], controller: "balance"

      get "status", to: "reports#show"

      get "send", to: "sms_campaigns#send_sms"
    end
  end
end
