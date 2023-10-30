require 'sidekiq/web'
require 'sidekiq/api'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount ActionCable.server, at: '/cable'
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
        resources :dashboard, only: %i[index]
      end

      namespace :kol do
        resources :google_calendar, only: %i[index create show update destroy] do
          collection do
            get 'check_integrate'
          end
        end
        resources :statistical, only: %i[index]
        resources :tasks, only: %i[ index create show  update destroy ] do
          member do
            put 'add_google_event_id'
          end
        end
        resources :kol_profiles, only: %i[index create edit] do
          collection do
            get 'gallaries'
            put 'edit_kol_profile'
            put 'change'
            put 'change_video'
            put 'upload_image'
            put 'delete_image'
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
        resources :statistical, only: %i[index]
        resources :bussiness_profiles, only: %i[index create] do
          collection do
            put 'change'
          end
        end
        resources :jobs, only: %i[index create update show edit] do
          member do
            delete 'cancle'
          end
          collection do
            post 'booking'
          end
        end

        resources :payment_intents, only: %i[create] do
          collection do
            put 'update_job'
          end
          member do
            get "retrieve"
          end
        end

        resources :invoices, only: %i[index show]

        resources :followers, only: %i[index] do
          member do
            delete "unfollow"
          end
          collection do
            post "follow"
          end
        end
      end
      resource :webhooks, only: %i[create]

      resources :notifications, only: %i[index create] do
        member do
          post 'read'
        end
      end
      resources :emoji_jobs, only: %i[index destroy] do
        member do
          post 'like'
          post 'unlike'
        end
      end

      resources :emoji_profiles, only: %i[index destroy] do
        member do
          post 'like'
          post 'unlike'
        end
      end

      resource :setup_profiles, only: %i[] do
        collection do
          post "base"
          post "kol"
        end
      end

      resources :industries, only: %i[index]
      resources :bussiness, only: %i[index show]
      resources :reports, only: %i[create]
      resources :kols, only: %i[index show]
      resources :reviews, only: %i[index create] do
        member do
          get 'reviews_by_reviewed'
        end
      end
      resources :jobs, only: %i[index show] do
        member do
          get 'jobs_by_owner'
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

  resources :google_auths, only: [] do
    collection do
      get 'callback'
      post "callback"
    end
  end

  resources :google_integrates, only: %i[create]

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
