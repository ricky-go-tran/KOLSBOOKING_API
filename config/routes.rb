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
        resources :jobs, only: %i[index] do
          member do
            put 'cancle'
          end
        end
        resources :reports, only: %i[index] do
          member do
            put 'proccess'
            put 'sovled'
            put 'rejected'
          end
        end
        resources :sidekiq_views, only: %i[] do
          collection do
            get 'get_job_current_moth'
          end
        end
      end
      namespace :kol do
        resources :statiscal, only: %i[] do
          collection do
            get 'index_month'
          end
        end
        resources :tasks, only: %i[ index create  update destroy ]
        resources :kol_profiles, only: %i[index create] do
          collection do
            put 'change'
          end
        end
        resources :bookmarks, only: %i[index] do
          collection do
            post 'mark'
            delete 'unmark'
          end
        end
        resources :jobs, only: %i[index] do
          member do
            put 'cancle'
            put 'apply'
            put 'complete'
            put 'finish'
            put 'payment'
            end
        end
      end
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
