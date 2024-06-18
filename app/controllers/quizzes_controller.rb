class QuizzesController < ApplicationController
  # show, continue, restart, grade, results 액션 전에 set_quiz 메서드를 호출
  before_action :set_quiz, only: [:show, :continue, :restart, :grade, :results]
  # 모든 액션 전에 로그인 여부를 확인
  before_action :require_login
  # create 액션에 대해 CSRF 보호를 비활성화
  skip_before_action :verify_authenticity_token, only: [:create]

  # index 액션: 현재 사용자의 모든 퀴즈를 페이지네이션
  def index
    @quizzes = current_user.quizzes.page(params[:page]).per(4)
  end

  # create 액션: 새로운 퀴즈를 생성
  def create
    # 랜덤으로 10개의 단어를 선택
    words = Word.order('RANDOM()').limit(10)
    # 새로운 퀴즈를 생성
    @quiz = current_user.quizzes.create!(title: "Quiz #{Time.now.strftime('%Y%m%d %H:%M:%S')}")
    # 선택된 단어들을 기반으로 질문을 생성
    words.each { |word| @quiz.questions.create!(word_id: word.id) }
    # 생성된 퀴즈 페이지로 리디렉션
    redirect_to quiz_path(@quiz)
  end

  # show 액션: 특정 퀴즈를 보여줌
  def showy
    # 퀴즈에 속한 모든 질문을 가져옴
    @questions = @quiz.questions
    # 첫 번째 질문을 현재 질문으로 설정
    @current_question = @questions.first
    # 이전 및 다음 질문 ID를 설정
    set_navigation_ids(@current_question)

    @word = @current_question.word
    @correct_answer = @word.mean
    @wrong_answers = Word.where.not(id: @word.id).order("RANDOM()").limit(3).pluck(:mean)
    @choices = (@wrong_answers + [@correct_answer]).shuffle
  end

  # continue 액션: 퀴즈를 이어서 진행
  def continue
    redirect_to quiz_path(@quiz)
  end

  # restart 액션: 퀴즈를 다시 시작
  def restart
    # 기존의 모든 질문을 삭제하고 새로운 질문을 생성
    @quiz.questions.destroy_all
    words = Word.order('RANDOM()').limit(10)
    words.each { |word| @quiz.questions.create!(word_id: word.id) }
    redirect_to quiz_path(@quiz)
  end

  # grade 액션: 퀴즈를 채점
  def grade
    # 모든 질문의 결과를 저장
    @results = @quiz.questions.map do |question|
      { word: question.word, user_answer: question.user_answer, correct: question.correct? }
    end

    # 퀴즈의 점수를 업데이트
    @quiz.update(score: @results.count { |result| result[:correct] })

    respond_to do |format|
      format.html { redirect_to quiz_path(@quiz) }
      format.js
    end
  end

  # results 액션: 퀴즈의 결과를 보여줌
  def results
    # 모든 질문의 결과를 저장
    @results = @quiz.questions.map do |question|
      { word: question.word, user_answer: question.user_answer, correct: question.correct? }
    end
  end

  private

  # set_quiz: 특정 퀴즈를 설정하는 메서드
  def set_quiz
    @quiz = current_user.quizzes.find(params[:id])
  end

  # require_login: 사용자가 로그인했는지 확인하는 메서드
  def require_login
    redirect_to login_path unless session[:user_id]
  end

  # set_navigation_ids: 이전 및 다음 질문 ID를 설정하는 메서드
  def set_navigation_ids(current_question)
    @previous_question_id = @questions.where('id < ?', current_question.id).order(:id).last&.id
    @next_question_id = @questions.where('id > ?', current_question.id).order(:id).first&.id
  end
end
