# app/controllers/pages_controller.rb
class PagesController < ApplicationController
    def about
      # You can add any instance variables here if needed
      # For example, if you want to fetch restaurant info:
      @restaurant_info = RestaurantInfo.first
    end

    def contact
      # Contact page action if needed
      @restaurant_info = RestaurantInfo.first
    end
end
