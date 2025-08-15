# app/controllers/password_resets_controller.rb
class PasswordResetsController < ApplicationController
    before_action :get_user, only: [:edit, :update]
    before_action :valid_user, only: [:edit, :update]
    before_action :check_expiration, only: [:edit, :update]
  
    def new
    end
  
    def create
      @user = User.find_by(email: params[:password_reset][:email].downcase)
      if @user
        @user.generate_password_reset_token!
        UserMailer.password_reset(@user).deliver_now
        redirect_to login_path, notice: "Password reset instructions sent to your email"
      else
        flash.now[:alert] = "Email address not found"
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if params[:user][:password].empty?
        @user.errors.add(:password, "can't be empty")
        render :edit
      elsif @user.update(user_params)
        @user.update(reset_password_token: nil)
        redirect_to login_path, notice: "Password has been reset successfully"
      else
        render :edit
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  
    def get_user
      @user = User.find_by(reset_password_token: params[:id])
    end
  
    def valid_user
      unless @user && @user.reset_password_token.present?
        redirect_to root_path, alert: "Invalid password reset link"
      end
    end
  
    def check_expiration
      if @user.password_reset_expired?
        redirect_to new_password_reset_path, alert: "Password reset link has expired"
      end
    end
  end