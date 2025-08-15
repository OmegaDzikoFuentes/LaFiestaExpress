class OrderMailer < ApplicationMailer
    def confirmation_email(order)
      @order = order
      mail(to: @order.contact_email, subject: "La Fiesta Express Order ##{order.id} Confirmation")
    end
end
