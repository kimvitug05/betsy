class CategorizationsController < ApplicationController

  def index
    @categorizations = Categorization.all
  end

  def show
    @categorization = Categorization.find_by(id: params[:id])

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
      flash[:success] = "Successfully created #{@categorization.name} #{@categorization.id}"
      redirect_to categorization_path(@categorization.id)
    else
      flash.now[:warning] = "A problem occurred: Could not create #{@categorization.name}"
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
