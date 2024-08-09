class TagsController < ApplicationController
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
      logger.debug "태그 생성 성공: #{@tag.id}, #{request.format.json?}"
      respond_to do |format|
        format.html { redirect_to tag_path(@tag) }
        format.json { render json: { id: @tag.id, name: @tag.name }, status: :created }
      end
    else
      logger.debug "태그 생성 실패: #{request.format.json?}"
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  rescue => e
    logger.error "태그 생성 중 오류 발생: #{e.message}"
    respond_to do |format|
      format.html { redirect_to new_tag_path, alert: '서버 오류가 발생했습니다.' }
      format.json { render json: { error: '서버 오류가 발생했습니다.' }, status: :internal_server_error }
    end
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update(tag_params)
      redirect_to tags_path
    else
      render :edit
    end
  end

  def destroy
    set_tag
    @tag.destroy
    redirect_to tags_path
  end

  private

  def set_tag
    @tag = current_user.tags.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

  def require_login
    redirect_to login_path unless session[:user_id]
  end
end
