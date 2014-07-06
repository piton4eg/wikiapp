Wikiapp::Application.routes.draw do
  root 'posts#index'

  get     '/add',                 to: 'posts#new', as: :new_root
  get     '/*ancestry_path/add',  to: 'posts#new'
  post    '/',                    to: 'posts#create'   
  post    '/*ancestry_path',      to: 'posts#create'
  get     '/*ancestry_path/edit', to: 'posts#edit'
  put     '/*ancestry_path',      to: 'posts#update'
  get     '/*ancestry_path',      to: 'posts#show'
end
