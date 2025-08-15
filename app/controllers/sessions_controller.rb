class SessionsController < ApplicationController
    skip_before_action :set_current_order, only: [ :new, :create ]

    def new
      clear_stored_location
    end

    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_path, notice: "Welcome back, #{user.first_name}!"
      else
        flash.now[:alert] = "Invalid email or password"
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_path, notice: "You have been logged out."
    end
end
