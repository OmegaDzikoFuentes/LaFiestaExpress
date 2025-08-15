class CustomizationsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!
    before_action :require_user_logged_in
    before_action :set_menu_item
    before_action :set_customization, only: [ :edit, :update, :destroy ]

    def index
      @customizations = @menu_item.customizations.order(:name)
    end

    def new
      @customization = @menu_item.customizations.new
    end

    def create
      @customization = @menu_item.customizations.new(customization_params)
      if @customization.save
        redirect_to menu_item_customizations_path(@menu_item), notice: "Customization was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @customization.update(customization_params)
        redirect_to menu_item_customizations_path(@menu_item), notice: "Customization was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @customization.destroy
      redirect_to menu_item_customizations_path(@menu_item), notice: "Customization was successfully deleted."
    end

    private

    def set_menu_item
      @menu_item = MenuItem.find(params[:menu_item_id])
    end

    def set_customization
      @customization = @menu_item.customizations.find(params[:id])
    end

    def customization_params
      params.require(:customization).permit(:name, :price_adjustment, :is_default)
    end
end
