RegistroIBPR::Application.routes.draw do
  resources :churches do
    resources :people
    resources :checks
  end

  resources :people

  get '/search', to: 'search#index'

  root 'dashboard#index'
end
