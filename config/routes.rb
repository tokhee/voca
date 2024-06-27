# config/routes.rb
Rails.application.routes.draw do
  root 'sessions#new'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get 'main_menu', to: 'main_menu#index'

  resources :tags
  resources :words

  post 'create_quiz', to: 'quizzes#create', as: 'create_quiz'

  get 'rankings', to: 'rankings#index'

  resources :quizzes do
    member do
      post :grade
      post :restart
      get :results
      get :continue
      post :save
    end
  end

  resources :questions, only: [:show, :update]

end
