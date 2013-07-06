TunrTdd::Application.routes.draw do
  root :to => 'home#index'

  resources :artists, only: [:index, :new, :edit, :show, :create, :update, :destroy]

end
