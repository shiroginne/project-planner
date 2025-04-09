Rails.application.routes.draw do
  root "projects#index"

  resources :projects, only: [ :index, :show, :create, :destroy ] do
    resources :tasks, only: [ :edit, :create, :update, :destroy ] do
      member do
        patch :complete
      end
    end
  end
end
