RegistroIBPR::Application.routes.draw do
  resources :churches do
    resources :people
    resources :checks
  end

  resources :people

  get '/people/:id/tag', to: 'people#tag'
  get '/search', to: 'search#index'
  get '/print', to: 'print#index'
  get '/print/flush', to: 'print#flush'

  root 'dashboard#index'
end
