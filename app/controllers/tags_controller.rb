class TagsController < ApplicationController
  # before_action :set_tag
  before_action :require_login
  def index
    @tags = current_user.tags.page(params[:page]).per(10)
    if params[:search].present?
      search_tag = "%#{params[:search]}%"
      @tags = @tags.where('name LIKE ?', search_tag)
    end
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = current_user.tags.build(tag_params)
    if @tag.save
      redirect_to tags_path
    else
      render :new
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    @tag = current_user.tags.build(tag_params)
    if @tag.save
      redirect_to tags_path
    else
      render :new
    end
  end

  def destroy
  end


  private

  # def set_tag
  #   @tag = current_user.tags.find(params[:id])
  #
  # end

  def tag_params
    params.require(:tag).permit(:name)
  end

  def require_login
    redirect_to login_path unless session[:user_id]
  end
end
