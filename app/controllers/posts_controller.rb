class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @tree_posts = Post.hash_tree
  end

  def show
    @subtree = @post.hash_tree
  end

  def new
    # Если пытаются создать подстраницу - проверить что страница существует
    parent = post_by_path_or_not_found if params[:ancestry_path].present?
    # URL для form
    @form_url = parent.try(:post_url) || '/'
    @post = Post.new
  end

  def edit
  end

  def create
    if params[:ancestry_path].present?
      parent = post_by_path_or_not_found
      @post = parent.children.new(post_params)
    else
      @post = Post.new(post_params)
    end

    if @post.save
      redirect_to @post.post_url, notice: 'Страница создана.'
    else
      # URL для form
      @form_url = parent.try(:post_url) || '/'
      render :new
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post.post_url, notice: 'Страница обновлена.' 
    else
      render :edit 
    end
  end

  private
    def set_post
      @post = post_by_path_or_not_found
    end

    def post_params
      params.require(:post).permit(:name, :title, :text, :ancestry_path)
    end

    # Если не удалось найти страницу - сгенерировать ошибку
    def post_by_path_or_not_found
      Post.find_by_path(params[:ancestry_path].split('/')) || not_found
    end
end
