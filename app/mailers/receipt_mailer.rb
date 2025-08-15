class ReceiptMailer < ApplicationMailer
    def punch_approved(receipt_upload)
      @receipt_upload = receipt_upload
      @user = receipt_upload.user
      @loyalty_card = receipt_upload.loyalty_card

      mail(
        to: @user.email,
        subject: "🎉 Loyalty Punch Added - #{@loyalty_card.punches_count}/10 punches!"
      )
    end

    def punch_rejected(receipt_upload)
      @receipt_upload = receipt_upload
      @user = receipt_upload.user

      mail(
        to: @user.email,
        subject: "Receipt Upload Update - La Fiesta Express"
      )
    end
end
