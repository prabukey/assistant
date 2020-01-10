Assistant::Engine.routes.draw do
  # resources :services
  namespace :api do
    namespace :dev do
      # resources :service
      post "service" => "service#conversation"

    end
  end
end
