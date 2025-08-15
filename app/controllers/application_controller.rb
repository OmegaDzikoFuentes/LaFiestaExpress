class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :exception
  helper_method :current_user, :user_signed_in?

  before_action :set_current_order, if: :user_signed_in?
  before_action :load_restaurant_info

  private

  def require_user_logged_in
    unless user_signed_in?
      store_location
      redirect_to login_path, alert: "Please log in to access this page."
    end
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    !!current_user
  end

  def store_location
    session[:return_to] = request.original_url
  end

  def redirect_back_or(default)
    redirect_to(session.delete(:return_to) || default)
  end

  def clear_stored_location
    session.delete(:return_to)
  end

  def authenticate_user!
    unless user_signed_in?
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end

  def authorize_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end

  def set_current_order
    return unless current_user

    @current_order = current_user.orders.find_by(status: "cart") ||
                     current_user.orders.create!(
                       status: "cart",
                       order_date: Time.current
                     )
  end

  def load_restaurant_info
    @restaurant_info = RestaurantInfo.first
  end
end
