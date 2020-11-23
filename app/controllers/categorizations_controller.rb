class CategorizationsController < ApplicationController

  before_action :find_categorization, only: [:show]
  before_action :require_login, only: [:new, :create]

  def index
    @categorizations = Categorization.all
  end

  def show
    if @categorization.nil?
      redirect_to categorizations_path
      return
    end
  end

  def new
    @categorization = Categorization.new
  end

  def create
    @categorization = Categorization.new(categorization_params)

    if @categorization.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created category: #{@categorization.name}"
      redirect_to categorization_path(@categorization.id)
    else
      flash[:status] = :failure
      flash.now[:result_text] = "Please enter a valid category name."
      render :new, status: :bad_request
    end
  end

  private

  def categorization_params
    return params.require(:categorization).permit(:name)
  end

  def find_categorization
    @categorization = Categorization.find_by_id(params[:id])
  end
end
