class CardsController < ApplicationController
  def index
    respond_with project, @cards = chain.all#, :layout => false
  end

  def new
    @card = Card.new
    @project = project
  end

  def show
    redirect_to project
  end

  def create
    respond_with project, @card = chain.create(card_params.merge({user: current_user}))#, :layout => false
  end

  def update
    respond_with project, @card = chain.update(params[:id], card_params)#, :layout => false
  end

  def destroy
    respond_with project, @card = chain.destroy(params[:id])#, :layout => false
  end

  private

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
