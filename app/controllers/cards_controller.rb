class CardsController < ApplicationController
  before_filter :init_project, only: [:new, :create, :update]

  def index
    respond_with project, @cards = chain.all #, :layout => false
  end

  def new
    @card = Card.new
  end

  def show
    redirect_to project
  end

  def create
    @card = chain.create(card_params.merge({user: current_user}))
    respond_with project, @card
  end

  def update
    respond_with project, @card = chain.update(params[:id], card_params)
  end

  def destroy
    respond_with project, @card = chain.destroy(params[:id]) #, :layout => false
  end

  private

  def card
    chain.find(params[:id])
  end

  def init_project
    @project = project
  end

  def card_params
    params[:card].merge user: current_user
  end

  def chain
    project.cards
  end

  def author
    @author ||= params[:user_id] ? User.find(params[:user_id]) : nil
  end

  def projects_chain
    @projects_chain ||= (author and author.projects) or Project
  end

  def project
    projects_chain.find(params[:project_id])
  end
end
