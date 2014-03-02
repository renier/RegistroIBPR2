RegistroIBPR::Application.routes.draw do
  resources :churches do
    resources :people
    resources :checks
  end

  resources :people

  get '/search', to: 'search#index'
  get '/print', to: 'print#index'
  get '/print/flush', to: 'print#flush'

  root 'dashboard#index'
end
