class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:new, :create]
    before_action :set_user, only: [:show, :edit, :update]
    before_action :authorize_user!, only: [:edit, :update]
  
    def new
      @user = User.new
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        session.clear
        session[:user_id] = @user.id
        redirect_to root_path, notice: "Welcome to La Fiesta! Account created."
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def update
      if @user.authenticate(params[:user][:current_password]) && @user.update(user_params)
        redirect_to @user, notice: "Profile updated!"
      else
        handle_update_errors
        render :edit, status: :unprocessable_entity
      end
    end
  
    private
  
    def handle_update_errors
      return if @user.authenticate(params[:user][:current_password])
      @user.errors.add(:current_password, "is invalid") 
      @user.restore_attributes # Prevent password change on failed auth
    end
  
    def user_params
      params.require(:user).permit(
        :first_name, :last_name, :username, 
        :email, :phone, :password, 
        :password_confirmation, :current_password
      )
    end
  end
