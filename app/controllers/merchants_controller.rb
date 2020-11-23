class MerchantsController < ApplicationController

  before_action :require_login, except: [:index, :create, :show]

  def dashboard
  end

  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")

    if merchant
      flash[:status] = :success
      flash[:result_text] = "Existing user #{merchant.username} is logged in."
    else
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:status] = :success
        flash[:result_text] = "Logged in as new user #{merchant.username}"
      else
        flash[:status] = :failure
        flash[:result_text] = "Could not create user account #{merchant.errors.messages}"
        redirect_to root_path
        return
      end
    end

    session[:user_id] = merchant.id
    redirect_to root_path
  end

  def index
    @merchants = Merchant.all
  end

  def show
    merchant_id = params[:id].to_i
    @merchant = Merchant.find_by(id: merchant_id)

    if @merchant.nil?
      redirect_to merchants_path
      return
    end
  end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out!"
    redirect_to root_path
  end
end
