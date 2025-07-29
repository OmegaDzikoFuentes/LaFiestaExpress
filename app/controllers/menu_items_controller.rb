class MenuItemsController < ApplicationController
  before_action :authorize_admin!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_menu_item, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :create, :edit, :update]

  def index
    @menu_items = if params[:category_id]
                    Category.find(params[:category_id]).menu_items.where(available: true).order(:name)
                  else
                    MenuItem.where(available: true).includes(:category).order('categories.name', :name)
                  end
  end

  def show
    @customizations = @menu_item.customizations.order(:name)
  end

  def new
    @menu_item = MenuItem.new
    @menu_item.category_id = params[:category_id] if params[:category_id]
  end

  def create
    @menu_item = MenuItem.new(menu_item_params)
    if @menu_item.save
      redirect_to @menu_item, notice: "Menu item was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @menu_item.update(menu_item_params)
      redirect_to @menu_item, notice: "Menu item was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @menu_item.destroy
    redirect_to menu_items_path, notice: "Menu item was successfully deleted."
  end

  private

  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  def set_categories
    @categories = Category.all.order(:name)
  end

  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price, :image_url, :category_id)
  end
end
