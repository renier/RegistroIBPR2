RegistroIBPR::Application.routes.draw do
  resources :churches do
    resources :people
    resources :checks
  end

  root 'home#index'
end
