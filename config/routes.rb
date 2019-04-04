Rails.application.routes.draw do
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    
    namespace "v1", defaults: {format: :json} do
    
        post    'login',    to: 'access_tokens#create'
        delete  'logout',   to: 'access_tokens#destroy'
    
        resources :articles, only: [:index, :show, :create, :update]

    end
    

end
