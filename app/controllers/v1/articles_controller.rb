class V1::ArticlesController < ApplicationController
    
    # before_action :set_params, only: [:create, :delete, :update]
    skip_before_action :authorize!, only: [:index, :show]
    
    def index

        articles = Article.recent.page(params[:page]).per(params[:per_page])
        render json: articles

        # @articles = Article.all
        # render :index
    end
    
    def show
    
    end
    
    private
    
    def set_params
        params.permit(:title, :content, :slug, :page, :per_page)
    end
end