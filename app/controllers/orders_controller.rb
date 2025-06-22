# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_order, only: [:show, :checkout, :complete, :add_loyalty_punch]
  
  def index
    @orders = current_user.orders.includes(:order_items, :menu_items).order(created_at: :desc)
  end
  
  def show
    @order_items = @order.order_items.includes(:menu_item, :customizations)
  end
  
  def new
    @order = current_user.orders.build
  end
  
  def create
    @order = current_user.orders.build(order_params)
    
    if @order.save
      redirect_to @order, notice: 'Order created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def checkout
    # Display checkout form
    @order.calculate_totals!
  end
  
  def complete
    if @order.update(status: 'completed', completed_at: Time.current)
      # Clear current cart items if this was the current order
      session[:current_order_id] = nil if session[:current_order_id] == @order.id
      
      redirect_to @order, notice: 'Order completed successfully!'
    else
      render :checkout, status: :unprocessable_entity
    end
  end
  
  def current
    @order = current_user.current_order
    
    if @order
      @order_items = @order.order_items.includes(:menu_item, :customizations)
      render :show
    else
      redirect_to menu_items_path, notice: 'Your cart is empty.'
    end
  end
  
  # NEW: Fixed loyalty punch functionality
  def add_loyalty_punch
    unless @order.completed?
      redirect_to @order, alert: 'Order must be completed to add loyalty punch.'
      return
    end
    
    loyalty_card = current_user.current_loyalty_card
    unless loyalty_card
      redirect_to @order, alert: 'No active loyalty card found.'
      return
    end
    
    # Check if this order already has a loyalty punch
    existing_punch = loyalty_card.loyalty_punches.find_by(order: @order)
    if existing_punch
      redirect_to @order, alert: 'This order already has a loyalty punch.'
      return
    end
    
    # For receipt-based system, redirect to upload receipt
    if params[:with_receipt] == 'true'
      session[:pending_loyalty_order_id] = @order.id
      redirect_to new_receipt_upload_path, notice: 'Please upload your receipt to earn your loyalty punch.'
    else
      # For automatic punch (if no receipt required)
      loyalty_punch = loyalty_card.loyalty_punches.create!(
        user: current_user,
        order: @order,
        punched_at: Time.current,
        is_approved: true  # Auto-approve if no receipt required
      )
      
      # Check if card is now complete
      if loyalty_card.current_punches >= loyalty_card.max_punches
        loyalty_card.update!(is_completed: true)
        redirect_to loyalty_card, notice: 'Loyalty punch added! Your card is now complete and ready to redeem!'
      else
        redirect_to @order, notice: "Loyalty punch added! #{loyalty_card.punches_remaining} more to go!"
      end
    end
  end
  
  private
  
  def set_order
    @order = current_user.orders.find(params[:id])
  end
  
  def order_params
    params.require(:order).permit(:notes, :special_instructions)
  end
end