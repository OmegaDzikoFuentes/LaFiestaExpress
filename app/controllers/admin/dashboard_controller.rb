class Admin::DashboardController < Admin::BaseController
    def index
      @total_revenue = Order.completed.sum(:total_amount)
      @popular_items = OrderItem.group(:menu_item_id).sum(:quantity).map do |id, count|
        { menu_item: MenuItem.find(id), quantity: count }
      end.sort_by { |item| -item[:quantity] }
    end
  end