Rails.application.routes.draw do
  root 'sessions#new'

  # ログイン / ログアウト
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'

  get  '/logout',  to: 'sessions#destroy'  # delete method
  delete  '/logout',  to: 'sessions#destroy'  # delete method

  get 'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get 'main_menu', to: 'main_menu#index'

  resources :tags do
    member do
      delete :destroy
    end
  end

  resources :words do
    member do
      delete :destroy
    end
  end

  resources :quizzes do
    member do
      get :continue
      get :restart
      get :show_answers
      get :grade
      post :grade
      get :results
      post :save
      delete :destroy
    end
  end

  post 'create_quiz', to: 'quizzes#create', as: 'create_quiz'

  resources :questions
  get 'rankings', to: 'rankings#index'
end
