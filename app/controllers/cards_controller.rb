class CardsController < ApplicationController
  before_filter :init_project, only: [:new, :create, :update]

  def index
    respond_with project, @cards = chain.all #, :layout => false
  end

  def new
    respond_with project, @card = chain.build
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

  def amazon_search
    @client = ASIN::Client.instance
    @current_page = params[:page].to_i || 1
    @items = @client.search Keywords: params[:q], SearchIndex: :All, ResponseGroup: :Medium, ItemPage: @current_page
    amazon_response = @client.last_response

    @total_results = amazon_response['ItemSearchResponse']['Items']['TotalResults']
    @total_pages   = amazon_response['ItemSearchResponse']['Items']['TotalPages']
    render layout: false
  end

  private

  def card
    chain.find(params[:id])
  end

  def init_project
    @project = project
  end

  def card_params
    params[:card]
  end

  def chain
    project.cards
  end

  def projects_chain
    @projects_chain ||= current_user.projects or Project
  end

  def project
    projects_chain.find(params[:project_id])
  end
end
