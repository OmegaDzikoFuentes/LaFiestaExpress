class RestaurantInfoController < ApplicationController
    before_action :authenticate_user!, except: [:show]
    before_action :authorize_admin!, except: [:show]
    before_action :set_restaurant_info, only: [:show, :edit, :update]
  
    def show
    end
  
    def edit
    end
  
    def update
      if @restaurant_info.update(restaurant_info_params)
        redirect_to restaurant_info_path, notice: "Restaurant information was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_restaurant_info
      @restaurant_info = RestaurantInfo.first_or_create
    end
  
    def restaurant_info_params
      params.require(:restaurant_info).permit(
        :name, :street, :city, :state, :zip_code, 
        :phone, :email, :logo_url,
        :monday_hours, :tuesday_hours, :wednesday_hours, 
        :thursday_hours, :friday_hours, :saturday_hours, :sunday_hours
      )
    end
  end