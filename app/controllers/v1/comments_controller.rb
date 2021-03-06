class V1::CommentsController < ApplicationController

    skip_before_action :authorize!, only: [:index]
    before_action :load_article

    def index
        comments = @article.comments.page(params[:page]).per(params[:per_page])
        
        render json: comments
    end

    def create
        @comment = @article.comments.build(comment_params.merge(user: current_user))
        
        if @comment.save!
            render json: @comment, status: :created, location: @article
        else
            render json: @comment, adapter: :json_api, serializer: ErrorSerializer, status: :unprocessable_entity
        end
    end
    
    
    private
    
    def comment_params
        params.require(:data).require(:attributes).permit(:content) || ActionController::Parameters.new
    end
    
    def load_article
        @article = Article.find(params[:article_id])
    end
end
