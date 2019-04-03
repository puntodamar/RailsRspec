class V1::ArticlesController < ApplicationController
    
    # before_action :set_params, only: [:create, :delete, :update]
    
    def index

        articles = Article.all
        render json: articles

        # @articles = Article.all
        # render :index
    end
    
    def show
    
    end
    
    private
    
    def set_params
        params.permit(:title, :content, :slug)
    end
end