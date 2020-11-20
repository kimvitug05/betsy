class ApplicationController < ActionController::Base

  before_action :find_merchant

  def render_404
    return render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  def current_order
    if !session[:order_id].nil?
      Order.find(session[:order_id])
    else
      Order.new
    end
  end

  private

  def find_merchant
    if session[:user_id]
      @login_user = Merchant.find_by(id: session[:user_id])
    end
  end

  def require_login
    if @login_user.nil?
      flash[:error] = "You must be logged in to do that"
      redirect_to root_path
    end
  end
end