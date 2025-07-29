# app/controllers/receipt_uploads_controller.rb
class ReceiptUploadsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_user_logged_in
    before_action :set_receipt_upload, only: [:show, :destroy]
    before_action :set_loyalty_card, only: [:new, :create]
    
    def index
      @receipt_uploads = current_user.receipt_uploads
                                     .includes(:loyalty_card, :loyalty_punch)
                                     .order(created_at: :desc)
                                     .page(params[:page])
    end
  
    def show
    end
  
    def new
      @receipt_upload = current_user.receipt_uploads.build
    end
  
    def create
      @receipt_upload = current_user.receipt_uploads.new(receipt_upload_params)
      @loyalty_card = current_user.current_loyalty_card
      unless @loyalty_card
        redirect_to receipt_uploads_path, alert: 'No active loyalty card found.'
        return
      end
      if @loyalty_card.completed?
        redirect_to receipt_uploads_path, alert: 'Loyalty card is already complete.'
        return
      end
      if @receipt_upload.save
        @loyalty_punch = @loyalty_card.loyalty_punches.create!(
          receipt_upload: @receipt_upload,
          punch_number: @loyalty_card.punches_count + 1,
          order_id: session[:pending_loyalty_order_id],
          created_at: Time.current
        )
        redirect_to receipt_uploads_path, notice: 'Receipt uploaded successfully.'
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    def destroy
      if @receipt_upload.pending?
        @receipt_upload.destroy
        redirect_to receipt_uploads_path, notice: 'Receipt upload cancelled.'
      else
        redirect_to receipt_uploads_path, 
                    alert: 'Cannot delete processed receipt.'
      end
    end
  
    private
  
    def set_receipt_upload
      @receipt_upload = current_user.receipt_uploads.find(params[:id])
    end
  
    def set_loyalty_card
      @loyalty_card = current_user.loyalty_cards.active.first
    end
  
    def receipt_upload_params
      params.require(:receipt_upload).permit(
        :receipt_image, 
        :receipt_total, 
        :receipt_date
      )
    end
  end