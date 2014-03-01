RegistroIBPR::Application.routes.draw do
  resources :churches do
    resources :people
    resources :checks
  end

  resources :people

  root 'dashboard#index'
end
