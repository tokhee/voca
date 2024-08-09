# app/controllers/words_controller.rb
require 'csv'

class WordsController < ApplicationController
  before_action :set_word, only: %i[show edit update destroy]
  before_action :require_login

  def index
    @words = current_user.words.order(created_at: :desc).page(params[:page]).per(10)

    if params[:search].present?
      search_word = "%#{params[:search]}%"
      @words = if params[:column].present?
                 case params[:column]
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
               else
                 @words.left_joins(:tags, :similars)
                       .where('words.title LIKE :search_word OR words.mean LIKE :search_word OR tags.name LIKE :search_word OR similars.similar LIKE :search_word', search_word: search_word)
                       .distinct
               end
    end

    respond_to do |format|
      format.html
      format.csv { print_csv }
    end
  end

  def show
  end

  def new
    @word = Word.new
    @similar = @word.similars.build
    @tags = current_user.tags
  end

  def create
    @word = current_user.words.build(word_params)

    if @word.save
      redirect_to @word
    else
      render :new
    end
  end

  def edit
    @tags = current_user.tags
  end

  def update
    if @word.update(word_params)
      redirect_to @word
    else
      render :edit
    end
  end

  def destroy
    set_word
    @word.destroy
    redirect_to words_path
  end

  private

  def set_word
    @word = current_user.words.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:title, :mean, tag_ids: [], similars_attributes: [:id, :word_id, :similar, :_destroy])
  end

  def require_login
    redirect_to login_path unless session[:user_id]
  end

  def print_csv
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
