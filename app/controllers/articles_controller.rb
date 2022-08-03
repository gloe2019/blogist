class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]
  # offset = (page - 1) * per_page_results
  # pg 1: (1 - 1) * 5 = 0 --> no offset, results 1-5 on pg
  # pg 2: (2 - 1) * 5 = 5 --> offset 5, results 6 - 10 on pg
  # on pg 3: (3 - 1) * 5 = 10 --> offset 10, results 11 - 15 on pg
  # Article.limit(5).offset(offset_num)

  def index
    results_per_page = 5
    article_count = Article.count
    @total_pages = article_count / results_per_page

    # # if page param not in range of (1..total_pages), delete param,
    # params.delete_if do |key, val|
    #   key == 'page' && !val.to_i.between?(1, @total_pages)
    # end
    page_param = params[:page].to_i
    @page = determine_page(page_param)

    # set @page to params if it exists, else @page will be nil...
    # @page = (params[:page].to_i if params.key?(:page))
    Rails.logger.debug { "Params: #{params}, Total Pages: #{@total_pages}. Page: #{@page} Nil Page?: #{@page.nil?}" }

    # if @page.nil?
    #   # put some kinda notice about invalid page, set @page to last page...
    #   @page = @total_pages
    # end

    offset = offset_num(@page)
    @articles = Article.limit(results_per_page).offset(offset)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article # use redirect_to when mutating app state, rather than render...
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to root_path, status: :see_other
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :body)
  end

  def offset_num(page_num)
    results_per_page = 5
    (page_num - 1) * results_per_page
  end

  def determine_page(page_param)
    if page_param < 1
      1
    elsif page_param > @total_pages
      @total_pages
    else
      page_param
    end
  end
end
