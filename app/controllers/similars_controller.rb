class SimilarsController < ApplicationController
  def new
    @similar = Similar.new
    @similar.build_word

  end

  def create
    @similar = Similar.new(similar_params)
    if @similar.save
      redirect_to @similar
    else
      render :new
    end
  end


  private

  def similar_params
    params.require(:similar).permit(:similar, word_attributes: [:title])
  end
end
