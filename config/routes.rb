Rails.application.routes.draw do
  devise_for :users
  root 'movies#index'
  
  resources :movies do
    # member do     #  test_movie GET    /movies/:id/test(.:format)     movies#test
    #   get '/test' => 'movies#test'  
    # end
    # collection do #  test_movies GET    /movies/test(.:format)         movies#test
    #   get '/test' => 'movies#test' 
    # end
    
    member do
      post '/comments' => 'movies#create_comment'
    end
    
    collection do
      delete '/comments/:comment_id' => 'movies#destroy_comment'
      patch '/comments/:comment_id' => 'movies#update_comment'
    end
end
  get '/likes/:movie_id' => 'movies#like_movie'

  
 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
