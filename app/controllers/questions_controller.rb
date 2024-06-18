class QuestionsController < ApplicationController
  # update 액션에 대해 CSRF 보호를 비활성화
  skip_before_action :verify_authenticity_token, only: [:update, :create, :grade]
  # show 및 update 액션 전에 set_question 메서드를 호출
  before_action :set_question, only: [:show, :update]

  # show 액션: 특정 질문을 보여줌
  def show
    @questions = @question.quiz.questions
    @current_question = @question
    set_navigation_ids(@current_question)

    @word = @current_question.word
    @correct_answer = @word.mean
    @wrong_answers = Word.where.not(id: @word.id).order("RANDOM()").limit(3).pluck(:mean)
    @choices = (@wrong_answers + [@correct_answer]).shuffle

    respond_to do |format|
      format.html
      format.js { render partial: 'questions/question', locals: { question: @current_question, choices: @choices, next_question_id: @next_question_id, question_index: @questions.index(@current_question) + 1, total_questions: @questions.size } }
    end
  end

  # update 액션: 특정 질문을 업데이트
  def update
    if @question.update(question_params)
      @questions = @question.quiz.questions
      set_navigation_ids(@question)

      if @next_question_id
        @current_question = @question.quiz.questions.find(@next_question_id)
        @word = @current_question.word
        @correct_answer = @word.mean
        @wrong_answers = Word.where.not(id: @word.id).order("RANDOM()").limit(3).pluck(:mean)
        @choices = (@wrong_answers + [@correct_answer]).shuffle

        respond_to do |format|
          format.html { redirect_to quiz_path(@question.quiz) }
          format.js { render partial: 'questions/question', locals: { question: @current_question, choices: @choices, next_question_id: @next_question_id, question_index: @questions.index(@current_question) + 1, total_questions: @questions.size } }
        end
      else
        respond_to do |format|
          format.html { redirect_to quiz_path(@question.quiz) }
          format.js { render partial: 'questions/question', locals: { question: @question, choices: @choices, next_question_id: nil, question_index: @questions.index(@question) + 1, total_questions: @questions.size } }
        end
      end
    else
      respond_to do |format|
        format.html { render :show }
        format.js { render partial: 'questions/question', locals: { question: @question, choices: @choices, next_question_id: @next_question_id, question_index: @questions.index(@question) + 1, total_questions: @questions.size } }
      end
    end
  end

  private

  # set_question: 특정 질문을 설정하는 메서드
  def set_question
    @question = Question.find(params[:id])
  end

  # question_params: 질문 업데이트 시 허용되는 파라미터를 설정하는 메서드
  def question_params
    params.require(:question).permit(:user_answer, :answered)
  end

  # set_navigation_ids: 이전 및 다음 질문 ID를 설정하는 메서드
  def set_navigation_ids(current_question)
    @previous_question_id = @questions.where('id < ?', current_question.id).order(:id).last&.id
    # 'id < ?', current_question.id : 현재 질문(current_question)의 ID보다 작은 ID를 가진 모든 질문을 선택
    # .order(:id) : 선택된 질문들을 ID 기준으로 오름차순으로 정렬
    # .last : 정렬된 질문들 중에서 마지막 질문을 선택
    # &.id : 선택된 질문이 존재하면 그 질문의 ID를 반환

    @next_question_id = @questions.where('id > ?', current_question.id).order(:id).first&.id
    # 'id > ?', current_question.id : 현재 질문(current_question)의 ID보다 큰 ID를 가진 모든 질문을 선택
    # .order(:id) : 선택된 질문들을 ID 기준으로 오름차순으로 정렬
    # .first : 정렬된 질문들 중에서 첫 번째 질문을 선택
    # &.id : 선택된 질문이 존재하면 그 질문의 ID를 반환

    # 로그 출력 추가
    Rails.logger.info "이전 문제 ID: #{@previous_question_id}"
    Rails.logger.info "다음 문제 ID: #{@next_question_id}"
  end
end
