Dummy::Application.routes.draw do
  resources :redirects
  root :to => 'redirects#index'
  
  get "*path" => RedisRedirect::Routes
end
