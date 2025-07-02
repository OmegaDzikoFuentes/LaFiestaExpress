class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :require_user_logged_in
    
    def show
      @user = current_user
      @loyalty_cards = current_user.loyalty_cards.includes(:loyalty_punches).order(created_at: :desc)
      @recent_orders = current_user.orders.includes(:order_items).order(created_at: :desc).limit(5)
      @current_loyalty_card = current_user.current_loyalty_card || 
                            current_user.loyalty_cards.create!(
                              punches_count: 0,
                              discount_amount: 8.00
                            )
      @total_savings = current_user.total_loyalty_savings
    end
    
    def edit
      @user = current_user
    end
    
    def update
      @user = current_user
      
      if requires_password_confirmation? && !@user.authenticate(params[:user][:current_password])
        @user.errors.add(:current_password, "is invalid")
        render :edit, status: :unprocessable_entity
        return
      end
      
      if @user.update(profile_params)
        redirect_to profile_path, notice: "Profile updated successfully!"
      else
        render :edit, status: :unprocessable_entity
      end
    end
    
    private
    
    def profile_params
      permitted = [:first_name, :last_name, :username, :email, :phone]
      
      # Only allow password changes if current password is provided
      if params[:user][:current_password].present?
        permitted += [:password, :password_confirmation]
      end
      
      params.require(:user).permit(permitted)
    end
    
    def requires_password_confirmation?
      # Require current password for sensitive changes
      sensitive_fields = ['email', 'username', 'password']
      changed_fields = profile_params.keys.map(&:to_s)
      
      (sensitive_fields & changed_fields).any? || params[:user][:password].present?
    end
  end