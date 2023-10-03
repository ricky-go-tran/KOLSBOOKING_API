require 'sidekiq/web'
require 'sidekiq/api'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :admin do
        resources :users, only: %i[index show create] do
          member do
            put 'lock'
            put 'unlock'
          end
        end
        resources :jobs, only: %i[index show] do
          member do
            put 'cancle'
          end
        end
        resources :reports, only: %i[index show] do
          member do
            put 'proccess'
            put 'sovled'
            put 'rejected'
          end
        end
        resources :sidekiq_views, only: %i[index] do
          collection do
            get 'get_job_current_moth'
          end
        end
      end
      namespace :kol do
        resources :statistical, only: %i[index]
        resources :tasks, only: %i[ index create  update destroy ]
        resources :kol_profiles, only: %i[index create] do
          collection do
            put 'change'
          end
        end
        resources :bookmarks, only: %i[index] do
          member do
            post 'mark'
            delete 'unmark'
          end
        end
        resources :jobs, only: %i[index show] do
          member do
            put 'cancle'
            put 'apply'
            put 'complete'
            put 'finish'
            put 'payment'
            end
        end
      end

      namespace :base do
        resources :jobs, only: %i[index create update show] do
          member do
            delete "cancle"
          end
          collection do
            post "booking"
          end
        end
      end

      resources :emoji_jobs, only: %i[] do
        member do
          post 'like'
          post 'unlike'
        end
      end
      resources :industries, only: %i[index]
      resources :reports, only: %i[create]
      resources :kols, only: %i[index show]
      resources :jobs, only: %i[index show]
      resources :profiles, only: %i[index create] do
        collection do
          put 'change'
        end
      end
    end
  end
  get 'current_user/index'

  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
