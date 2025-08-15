class AdminMailer < ApplicationMailer
    def new_receipt_upload(admin, receipt_upload)
      @admin = admin
      @receipt_upload = receipt_upload
      @user = receipt_upload.user
      
      mail(
        to: @admin.email,
        subject: "New Receipt Upload Pending Review"
      )
    end
  end