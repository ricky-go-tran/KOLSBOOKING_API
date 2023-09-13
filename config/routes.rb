Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :admin do
        resources :users, only: %i[index show create] do
          collection do
            put 'lock'
            put 'unlock'
          end
        end
        resources :jobs, only: %i[index]
      end
      resources :profiles, only: %i[index create update]
    end
  end
  get 'current_user/index'
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
