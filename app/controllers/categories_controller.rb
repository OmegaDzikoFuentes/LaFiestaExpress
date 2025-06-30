class CategoriesController < ApplicationController
    before_action :authorize_admin!, only: [:new, :create, :edit, :update, :destroy]
    before_action :set_category, only: [:show, :edit, :update, :destroy]
  
    def index
      @banner_photos = BannerPhoto.all
      @categories = Category.all.order(:name)
      @restaurant_info = RestaurantInfo.first
    end
  
    def show
      @menu_items = @category.menu_items.order(:name)
    end
  
    def new
      @category = Category.new
    end
  
    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to categories_path, notice: "Category was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
    end
  
    def update
      if @category.update(category_params)
        redirect_to @category, notice: "Category was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @category.destroy
      redirect_to categories_path, notice: "Category was successfully deleted."
    end
  
    private
  
    def set_category
      @category = Category.find(params[:id])
    end
  
    def category_params
      params.require(:category).permit(:name, :description, :image_url)
    end
  end