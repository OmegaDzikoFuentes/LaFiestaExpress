class UsersController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      session.clear
      session[:user_id] = @user.id
      
      # Create initial loyalty card for new user
      @user.loyalty_cards.create!
      
      redirect_to root_path, notice: "Welcome to La Fiesta! Your account has been created and your loyalty card is ready."
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  
  def destroy
    # Allow users to delete their own account
    if current_user.destroy
      session.clear
      redirect_to root_path, notice: "Your account has been deleted."
    else
      redirect_to profile_path, alert: "Unable to delete account."
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :username, 
      :email, :phone, :password, :password_confirmation
    )
  end
end
