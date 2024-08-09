class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :restart, :grade, :results, :continue, :save, :destroy]
  before_action :require_login
  skip_before_action :verify_authenticity_token

  def index
    @quizzes = current_user.quizzes.order(created_at: :desc).page(params[:page])
  end

  def show
    @questions = @quiz.questions.order(:question_order)
    @current_question = @quiz.current_question

    if @current_question
      set_navigation_ids(@current_question)
      load_question_data(@current_question)
    else
      redirect_to quizzes_path, alert: '퀴즈에 질문이 없습니다.'
    end
    respond_to do |format|
      format.html
    end
  end

  def create
    ActiveRecord::Base.transaction do
      words = current_user.words.order('RANDOM()').limit(10)
      @quiz = current_user.quizzes.create!(title: "Quiz")

      words.each_with_index do |word, index|
        question = @quiz.questions.create!(word_id: word.id, question_order: index + 1)
        @quiz.update!(current_question: question) if index.zero?
      end

      if @quiz.current_question
        redirect_to quiz_path(@quiz)
      else
        raise ActiveRecord::Rollback, "퀴즈 생성에 실패했습니다."
      end
    end
  rescue => e
    redirect_to quizzes_path, alert: "퀴즈 생성에 실패했습니다: #{e.message}"
  end

  def restart
    @quiz.questions.destroy_all
    words = current_user.words.order('RANDOM()').limit(10)
    words.each_with_index { |word, index| @quiz.questions.create!(word_id: word.id, question_order: index + 1) }
    @quiz.update!(current_question: @quiz.questions.first)
    redirect_to quiz_path(@quiz)
  end

  def grade
    @results = @quiz.questions.map do |question|
      {
        word: question.word,
        user_answer: question.user_answer,
        correct: question.correct?
      }
    end

    @quiz.calculate_score
    current_user.update_user_score_and_rankings

    redirect_to results_quiz_path(@quiz)
  end

  def results
    @results = @quiz.questions.map do |question|
      {
        word: question.word,
        user_answer: question.user_answer,
        correct: question.correct?
      }
    end
    @quiz.calculate_score
    current_user.update_user_score_and_rankings
  end

  def continue
    @questions = @quiz.questions.order(:question_order)
    @current_question = @quiz.current_question

    if @current_question.nil?
      @current_question = @questions.first
      @quiz.update!(current_question: @current_question)
    end

    if @current_question
      set_navigation_ids(@current_question)
      load_question_data(@current_question)
    end

    respond_to do |format|
      format.html { render :show }
    end
  end

  def save
    if @quiz.update(current_question_id: params[:current_question_id])
      redirect_to quizzes_path, notice: 'Quiz progress saved successfully.'
    else
      redirect_to quiz_path(@quiz), alert: 'Failed to save quiz progress.'
    end
  end

  def destroy
    @quiz.destroy
    redirect_to quizzes_path, notice: 'Quiz was successfully deleted.'
  end

  private

  def set_quiz
    @quiz = current_user.quizzes.find(params[:id])
  end

  def require_login
    redirect_to login_path unless session[:user_id]
  end

  def set_navigation_ids(current_question)
    @previous_question_id = @quiz.questions.where('question_order < ?', current_question.question_order).order(:question_order).last&.id
    @next_question_id = @quiz.questions.where('question_order > ?', current_question.question_order).order(:question_order).first&.id
  end


  def load_question_data(current_question)
    @word = current_question.word
    @correct_answer = @word.mean
    @wrong_answers = Word.where.not(id: @word.id).order("RANDOM()").limit(3).pluck(:mean)
    @choices = (@wrong_answers + [@correct_answer]).shuffle
  end
end


# class QuizzesController < ApplicationController
#   before_action :set_quiz, only: [:show, :restart, :grade, :results, :continue, :save, :destroy]
#   before_action :require_login
#   skip_before_action :verify_authenticity_token
#
#   def index
#     @quizzes = current_user.quizzes.order(created_at: :desc).page(params[:page])
#   end
#
#   def show
#     @questions = @quiz.questions.order(:question_order)
#     @current_question = @quiz.current_question
#
#     if @current_question
#       set_navigation_ids(@current_question)
#       load_question_data(@current_question)
#     else
#       redirect_to quizzes_path, alert: '퀴즈에 질문이 없습니다.'
#     end
#     respond_to do |format|
#       format.html
#     end
#   end
#
#   def create
#     ActiveRecord::Base.transaction do
#       words = current_user.words.order('RANDOM()').limit(10)
#       @quiz = current_user.quizzes.create!(title: "Quiz")
#
#       words.each_with_index do |word, index|
#         question = @quiz.questions.create!(word_id: word.id, question_order: index + 1)
#         @quiz.update!(current_question: question) if index == 0
#       end
#
#       if @quiz.current_question
#         redirect_to quiz_path(@quiz)
#       else
#         raise ActiveRecord::Rollback, "퀴즈 생성에 실패했습니다."
#       end
#     end
#   rescue => e
#     redirect_to quizzes_path, alert: "퀴즈 생성에 실패했습니다: #{e.message}"
#   end
#
#   def restart
#     @quiz.questions.destroy_all
#     words = current_user.words.order('RANDOM()').limit(10)
#     words.each_with_index { |word, index| @quiz.questions.create!(word_id: word.id, question_order: index + 1) }
#     @quiz.update!(current_question: @quiz.questions.first)
#     redirect_to quiz_path(@quiz)
#   end
#
#   def grade
#     @results = @quiz.questions.map do |question|
#       {
#         word: question.word,
#         user_answer: question.user_answer,
#         correct: question.correct?
#       }
#     end
#
#     @quiz.calculate_score
#     current_user.update_user_score_and_rankings
#
#     redirect_to results_quiz_path(@quiz)
#   end
#
#   def results
#     @results = @quiz.questions.map do |question|
#       {
#         word: question.word,
#         user_answer: question.user_answer,
#         correct: question.correct?
#       }
#     end
#     @quiz.calculate_score
#     current_user.update_user_score_and_rankings
#   end
#
#   def continue
#     @questions = @quiz.questions.order(:question_order)
#     @current_question = @quiz.current_question
#
#     if @current_question.nil?
#       @current_question = @questions.first
#       @quiz.update!(current_question: @current_question)
#     end
#
#     if @current_question
#       set_navigation_ids(@current_question)
#       load_question_data(@current_question)
#     end
#
#     respond_to do |format|
#       format.html { render :show }
#     end
#   end
#
#   def save
#     if @quiz.update(current_question_id: params[:current_question_id])
#       redirect_to quizzes_path, notice: 'Quiz progress saved successfully.'
#     else
#       redirect_to quiz_path(@quiz), alert: 'Failed to save quiz progress.'
#     end
#   end
#
#   def destroy
#     @quiz.destroy
#     redirect_to quizzes_path, notice: 'Quiz was successfully deleted.'
#   end
#
#   private
#
#   def set_quiz
#     @quiz = current_user.quizzes.find(params[:id])
#   end
#
#   def require_login
#     redirect_to login_path unless session[:user_id]
#   end
#
#   def set_navigation_ids(current_question)
#     @previous_question_id = @quiz.previous_question(current_question)&.id
#     @next_question_id = @quiz.next_question(current_question)&.id
#   end
#
#   def load_question_data(current_question)
#     @word = current_question.word
#     @correct_answer = @word.mean
#     @wrong_answers = Word.where.not(id: @word.id).order("RANDOM()").limit(3).pluck(:mean)
#     @choices = (@wrong_answers + [@correct_answer]).shuffle
#   end
# end
