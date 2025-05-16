class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order, only: [:show, :edit, :update, :destroy, :checkout, :complete]
    before_action :authorize_order_access!, only: [:show, :edit, :update, :destroy]
  
    def index
      @orders = current_user.orders.order(created_at: :desc)
    end
  
    def show
      @order_items = @order.order_items.includes(:menu_item, :order_item_customizations)
    end
  
    def new
      @order = current_user.orders.new(
        order_date: Time.current,
        status: "cart"
      )
      if @order.save
        redirect_to menu_items_path, notice: "Started a new order. Add items to your cart!"
      else
        redirect_to root_path, alert: "Could not create a new order. Please try again."
      end
    end
  
    def checkout
      if @order.order_items.empty?
        redirect_to menu_items_path, alert: "Your cart is empty! Add items before checkout."
        return
      end
      
      @order.contact_name = current_user.full_name
      @order.contact_email = current_user.email
      @order.contact_phone = current_user.phone
    end
  
    def complete
      if @order.update(order_params.merge(status: "placed"))
        session[:order_id] = nil
        redirect_to @order, notice: "¡Gracias! Your order has been placed successfully."
      else
        render :checkout, status: :unprocessable_entity
      end
    end
  
    def current
      if session[:order_id] && (order = current_user.orders.find_by(id: session[:order_id], status: "cart"))
        redirect_to order_path(order)
      else
        redirect_to new_order_path
      end
    end
  
    private
  
    def set_order
      @order = Order.find(params[:id])
    end
  
    def authorize_order_access!
      unless @order.user_id == current_user.id || current_user.admin?
        redirect_to root_path, alert: "You are not authorized to access this order."
      end
    end
  
    def order_params
      params.require(:order).permit(
        :contact_name, :contact_phone, :contact_email,
        :pickup_time, :special_instructions
      )
    end
  end