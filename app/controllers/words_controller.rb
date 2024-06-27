# app/controllers/words_controller.rb

require 'csv'

class WordsController < ApplicationController
  before_action :set_word, only: %i[show edit update destroy]
  before_action :require_login

  def index
    @words = current_user.words.includes(:tags, :similars).page(params[:page]).per(10)

    if params[:search].present?
      search_word = "%#{params[:search]}%"
      @words = case params[:column]
               when 'title'
                 @words.where('title LIKE ?', search_word)
               when 'mean'
                 @words.where('mean LIKE ?', search_word)
               when 'tag'
                 @words.joins(:tags).where('tags.name LIKE ?', search_word)
               when 'similar'
                 @words.joins(:similars).where('similars.similar LIKE ?', search_word)
               else
                 @words
               end
    end

    respond_to do |format|
      format.html
      format.csv { send_csv }
    end
  end


  def show
  end

  def new
    @word = Word.new
    @word.similars.build
    @tags = Tag.all
  end

  def create
    @word = current_user.words.build(word_params)
    @word.tag_ids = params[:word][:tag_ids]

    if @word.save
      redirect_to @word
    else
      render :form
    end
  end

  def edit
    @tags = Tag.all
  end

  def update
    if @word.update(word_params)
      redirect_to @word
    else
      render :edit
    end
  end

  def destroy
    @word.destroy
    redirect_to words_url, notice: 'Word was successfully destroyed.'
  end

  private

  def set_word
    @word = current_user.words.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:title, :mean, tag_ids: [], similars_attributes: [:id, :similar, :_destroy])
  end

  def require_login
    unless session[:user_id]
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_url
    end
  end

  def send_csv
    csv_data = CSV.generate do |csv|
      csv << %w[title mean similar]
      @words.each do |word|
        similar_words = word.similars.pluck(:similar).join(", ")
        csv << [word.title, word.mean, similar_words]
      end
    end
    send_data(csv_data, filename: "words-#{DateTime.now.strftime('%d%m%Y%H%M')}.csv")
  end
end
