RegistroIBPR::Application.routes.draw do
  resources :churches do
    resources :people
    resources :checks
  end

  get '/people', to: 'people#all'

  root 'dashboard#index'
end
