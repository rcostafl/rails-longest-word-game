Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/new', to: 'games#new', as: 'new_prefix'

  post '/score', to: 'games#score', as: 'score'

    #get '/answer', to: 'questions#answer', as: 'answer'
end
