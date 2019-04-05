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
        article = Article.find(params[:id])
        render json: article
    end
    
    def create
        article = current_user.articles.build(article_params)
        if article.valid?
            article.save!
            render json: article, status: :created
        else
            render json:        article,
                   adapter:     :json_api,
                   serializer:  ActiveModel::Serializer::ErrorSerializer,
                   status:      :unprocessable_entity
        end
    end
    
    def update
        article = current_user.articles.find(params[:id])
        article.update_attributes!(article_params)
        render json: article, status: :ok
    
        rescue ActiveRecord::RecordNotFound
            authorization_error
        
        rescue
            render json:        article,
                   adapter:     :json_api,
                   serializer:  ActiveModel::Serializer::ErrorSerializer,
                   status:      :unprocessable_entity
    end
    
    def destroy
        article = current_user.articles.find(params[:id])
        article.destroy
        head :no_content
        
        rescue
            authorization_error
    end
    
    private
    
    def article_params
        params.require(:data).require(:attributes).permit(:title, :content,:slug) || ActionController::Parameters.new
        # params.permit(:title, :content, :slug, :page, :per_page)
    end
end