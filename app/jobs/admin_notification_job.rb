class AdminNotificationJob < ApplicationJob
  queue_as :default
  
  def perform(notification_type, record_id)
    case notification_type
    when 'new_receipt_upload'
      receipt_upload = ReceiptUpload.find(record_id)
      # Send email/SMS to admins
      User.where(admin: true).find_each do |admin|
        AdminMailer.new_receipt_upload(admin, receipt_upload).deliver_now
      end
    end
  end
end