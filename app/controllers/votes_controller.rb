class VotesController < ApplicationController
  before_filter :require_card

  def create
    current_user.vote @card, :up
    redirect_to :back
  end

  def destroy
    current_user.unvote @card
    redirect_to :back
  end

  private

  def require_card
    @card = Card.find(params[:card_id])
  end
end