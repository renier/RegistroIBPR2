Rails.application.routes.draw do
  resources :churches do
    resources :people
    resources :checks
  end

  resources :people

  get '/people/:id/tag', to: 'people#tag'
  put '/people/:ids/update_bulk', to: 'people#update_bulk'
  get '/search', to: 'search#index'
  get '/print', to: 'print#index'
  get '/print/flush', to: 'print#flush'
  get '/print/page', to: 'print#page'
  get '/print/export', to: 'print#export'

  get '/reports', to: 'reports#index'
  get '/reports/present_churches', to: 'reports#present_churches'
  get '/reports/arriving_churches', to: 'reports#arriving_churches'
  get '/reports/missing_churches', to: 'reports#missing_churches'
  get '/reports/full_roster', to: 'reports#full_roster'
  get '/reports/churches_with_balance', to: 'reports#churches_with_balance'

  root 'dashboard#index'
end
