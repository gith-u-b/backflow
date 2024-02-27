Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  Rails.application.routes.draw do
    mount ExceptionTrack::Engine => "/exception-track"
  end
  
  root "homes#index"

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      post :signup, to: 'registrations#create'
      post :signin, to: 'sessions#create'

      resources :contacts
    end
  end
end
