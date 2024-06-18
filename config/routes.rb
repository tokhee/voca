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

  resources :quizzes do
    member do
      get :continue
      get :restart
      get :show_answers
      get :grade
      get :results
    end
  end

  post 'create_quiz', to: 'quizzes#create', as: 'create_quiz'

  resources :questions
  get 'rankings', to: 'rankings#index'
end
