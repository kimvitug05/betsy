class MerchantsController < ApplicationController

  def create
    auth_hash = request.env["omniauth.auth"]
    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")

    if merchant
      flash[:success] = "Logged in as returning user #{merchant.username}"
    else
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:success] = "Logged in as new user #{merchant.username}"
      else
        flash[:error] = "Could not create new user account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end
  end

  def index
  end

  def show
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end
end
