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

  get '/reports', to: 'reports#index'
  get '/reports/present_churches', to: 'reports#present_churches'
  get '/reports/registered_churches', to: 'reports#registered_churches'
  get '/reports/missing_churches', to: 'reports#missing_churches'
  get '/reports/full_roster', to: 'reports#full_roster'
  get '/reports/churches_with_balance', to: 'reports#churches_with_balance'

  root 'dashboard#index'
end
