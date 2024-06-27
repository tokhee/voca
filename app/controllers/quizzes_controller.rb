class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show, :restart, :grade, :results, :continue, :save]
  before_action :require_login
  skip_before_action :verify_authenticity_token

  def index
    @quizzes = current_user.quizzes.page(params[:page]).per(4)
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
    words = current_user.words.order('RANDOM()').limit(10)
    @quiz = current_user.quizzes.create!(title: "Quiz #{Time.now.strftime('%Y%m%d %H:%M:%S')}")
    words.each_with_index { |word, index| @quiz.questions.create!(word_id: word.id, question_order: index + 1) }
    redirect_to quiz_path(@quiz)
  end

  def restart
    @quiz.questions.destroy_all
    words = current_user.words.order('RANDOM()').limit(10)
    words.each_with_index { |word, index| @quiz.questions.create!(word_id: word.id, question_order: index + 1) }
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
    redirect_to results_quiz_path(@quiz)
  end

  def results
    @results = @quiz.questions.map do |question|
      { word: question.word, user_answer: question.user_answer, correct: question.correct? }
    end
  end

  def continue
    @questions = @quiz.questions.order(:question_order)
    @current_question = @quiz.current_question

    if @current_question
      set_navigation_ids(@current_question)
      load_question_data(@current_question)
    end

    respond_to do |format|
      format.html { render :show }
    end
  end

  def save
    @quiz.update(current_question_id: params[:current_question_id])
    redirect_to quizzes_path, notice: 'Quiz progress saved successfully.'
  end

  private

  def set_quiz
    @quiz = current_user.quizzes.find(params[:id])
  end

  def require_login
    redirect_to login_path unless session[:user_id]
  end

  def set_navigation_ids(current_question)
    @previous_question_id = @quiz.previous_question&.id
    @next_question_id = @quiz.next_question&.id
  end

  def load_question_data(current_question)
    @word = current_question.word
    @correct_answer = @word.mean
    @wrong_answers = Word.where.not(id: @word.id).order("RANDOM()").limit(3).pluck(:mean)
    @choices = (@wrong_answers + [@correct_answer]).shuffle
  end
end
