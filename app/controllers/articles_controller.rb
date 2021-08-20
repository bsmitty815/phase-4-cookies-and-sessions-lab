class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    # session tracker goes here
    page_count = 3
    # session is data stored in the server side
    # cookies is data stored in the client side
    session[:pageviews_remaining] ||= page_count
    session[:pageviews_remaining] -= 1
    article = Article.find(params[:id])

    if session[:pageviews_remaining] > 0
      
      render json: article
    else
      render json: { error: "Maximum pageview limit reached" }, status: 401
    end
    
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
