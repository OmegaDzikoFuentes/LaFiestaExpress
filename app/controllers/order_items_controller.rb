class OrderItemsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_user_logged_in
    before_action :set_order, only: [ :create ]
    before_action :set_order_item, only: [ :destroy, :update ]
    before_action :ensure_cart_status, only: [ :create, :update, :destroy ]

    def create
      @order = current_user.current_order || current_user.orders.create!(status: "cart", order_date: Time.current)
      @menu_item = MenuItem.find(params[:menu_item_id])
      @order_item = @order.order_items.new(
        menu_item: @menu_item,
        item_name: @menu_item.name,
        item_price: @menu_item.price,
        quantity: params[:quantity] || 1,
        special_request: params[:special_request]
      )
      if @order_item.save
        add_customizations
        @order.calculate_totals
        redirect_to menu_items_path, notice: "#{@menu_item.name} added to your order!"
      else
        redirect_to menu_item_path(@menu_item), alert: "Could not add item to your order."
      end
    end

    def show
      @order_item = OrderItem.find(params[:id])
    end

    def update
      if @order_item.update(order_item_params)
        recalculate_order_totals
        redirect_to order_path(@order_item.order), notice: "Item updated successfully."
      else
        redirect_to order_path(@order_item.order), alert: "Could not update item."
      end
    end

    def destroy
      @order = @order_item.order
      @order_item.destroy
      recalculate_order_totals
      redirect_to order_path(@order), notice: "Item removed from your order."
    end

    private

    def set_order
      @order = if session[:order_id]
                current_user.orders.find_by(id: session[:order_id], status: "cart")
      end

      unless @order
        @order = current_user.orders.create(order_date: Time.current, status: "cart")
        session[:order_id] = @order.id
      end
    end

    def set_order_item
      @order_item = OrderItem.find(params[:id])
      # Security check to ensure the order item belongs to the current user
      unless @order_item.order.user_id == current_user.id
        redirect_to root_path, alert: "You are not authorized to modify this order item."
      end
    end

    def ensure_cart_status
      order = @order || @order_item.order
      unless order.status == "cart"
        redirect_to order_path(order), alert: "This order can no longer be modified."
      end
    end

    def add_customizations
      return unless params[:customizations].present?

      params[:customizations].each do |customization_id, selected|
        next unless selected == "1"

        customization = Customization.find(customization_id)
        @order_item.order_item_customizations.create(
          customization_name: customization.name,
          price_adjustment: customization.price_adjustment
        )
      end
    end

    def recalculate_order_totals
      order = @order || @order_item.order
      subtotal = order.order_items.sum do |item|
        item_total = item.item_price * item.quantity
        customization_total = item.order_item_customizations.sum { |c| c.price_adjustment || 0 }
        item_total + (customization_total * item.quantity)
      end

      tax = subtotal * 0.0825 # 8.25% tax rate - adjust as needed

      order.update(
        subtotal: subtotal,
        tax: tax,
        total_amount: subtotal + tax
      )
    end

    def order_item_params
      params.require(:order_item).permit(:quantity, :special_request)
    end
end
