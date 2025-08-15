class Admin::ReceiptUploadsController < Admin::BaseController
  before_action :set_receipt_upload, only: [:show, :approve, :reject]

  def index
    @pending_uploads = ReceiptUpload.pending
                                   .includes(:user, :loyalty_card, :loyalty_punch)
                                   .order(created_at: :asc)
    @recent_processed = ReceiptUpload.where.not(status: 'pending')
                                    .includes(:user, :loyalty_card, :loyalty_punch)
                                    .order(updated_at: :desc)
                                    .limit(20)
  end

  def show
  end

  def approve
    ActiveRecord::Base.transaction do
      @receipt_upload.update!(
        status: 'approved',
        approved_at: Time.current,
        approved_by_id: current_user.id,
        admin_notes: params[:admin_notes]
      )
      loyalty_punch = @receipt_upload.loyalty_punch
      loyalty_punch.update!(
        status: 'approved',
        approved_at: Time.current
      )
      loyalty_card = @receipt_upload.loyalty_card
      loyalty_card.increment!(:punches_count)
      if loyalty_card.punches_count >= loyalty_card.max_punches
        loyalty_card.update!(
          is_completed: true,
          completed_at: Time.current
        )
      end
    end
    redirect_to admin_receipt_uploads_path, notice: 'Receipt approved and punch added!'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to admin_receipt_uploads_path, alert: "Failed to approve receipt: #{e.message}"
  end

  def reject
    ActiveRecord::Base.transaction do
      @receipt_upload.update!(
        status: 'rejected',
        approved_by_id: current_user.id,
        admin_notes: params[:admin_notes]
      )
      if @receipt_upload.loyalty_punch
        @receipt_upload.loyalty_punch.update!(
          status: 'rejected',
          rejected_at: Time.current
        )
      end
    end
    ReceiptMailer.punch_rejected(@receipt_upload).deliver_later
    redirect_to admin_receipt_uploads_path, notice: 'Receipt rejected.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to admin_receipt_uploads_path, alert: "Failed to reject receipt: #{e.message}"
  end

  private

  def set_receipt_upload
    @receipt_upload = ReceiptUpload.find(params[:id])
  end
end