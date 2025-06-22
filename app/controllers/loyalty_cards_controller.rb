# app/controllers/loyalty_cards_controller.rb
class LoyaltyCardsController < ApplicationController
    before_action :require_user_logged_in
    before_action :set_loyalty_card, only: [:show, :redeem]
    
    def index
      @loyalty_cards = current_user.loyalty_cards.includes(:loyalty_punches).order(created_at: :desc)
      @current_card = current_user.current_loyalty_card
    end
    
    def show
      @loyalty_punches = @loyalty_card.loyalty_punches.includes(:receipt_upload).order(created_at: :desc)
    end
    
    def create
      # Only create a new card if user doesn't have an active one
      if current_user.current_loyalty_card.present?
        redirect_to loyalty_cards_path, alert: 'You already have an active loyalty card.'
        return
      end
      
      @loyalty_card = current_user.loyalty_cards.build(loyalty_card_params)
      
      if @loyalty_card.save
        redirect_to @loyalty_card, notice: 'Loyalty card created successfully!'
      else
        redirect_to loyalty_cards_path, alert: 'Failed to create loyalty card.'
      end
    end
    
    def current_card
      @loyalty_card = current_user.current_loyalty_card
      
      if @loyalty_card
        render json: {
          id: @loyalty_card.id,
          current_punches: @loyalty_card.current_punches,
          max_punches: @loyalty_card.max_punches,
          progress_percentage: @loyalty_card.progress_percentage,
          can_be_redeemed: @loyalty_card.can_be_redeemed?,
          reward_description: @loyalty_card.reward_description
        }
      else
        render json: { error: 'No active loyalty card found' }, status: :not_found
      end
    end
    
    def redeem
      unless @loyalty_card.can_be_redeemed?
        redirect_to @loyalty_card, alert: 'This loyalty card cannot be redeemed yet.'
        return
      end
      
      if @loyalty_card.redeem!
        redirect_to loyalty_cards_path, notice: 'Congratulations! Your loyalty card has been redeemed!'
      else
        redirect_to @loyalty_card, alert: 'Failed to redeem loyalty card.'
      end
    end
    
    private
    
    def set_loyalty_card
      @loyalty_card = current_user.loyalty_cards.find(params[:id])
    end
    
    def loyalty_card_params
      # For now, use default values. In the future, you might allow customization
      {
        max_punches: 10,
        reward_description: "Free menu item of your choice!"
      }
    end
  end