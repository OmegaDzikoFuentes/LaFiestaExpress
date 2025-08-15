module LoyaltyCardsHelper
    def status_class(card)
      if card.redeemed?
        "status-redeemed"
      elsif card.completed?
        "status-completed"
      else
        "status-active"
      end
    end

    def status_icon(card)
      if card.redeemed?
        "fa-check-circle"
      elsif card.completed?
        "fa-gift"
      else
        "fa-star"
      end
    end

    def status_text(card)
      if card.redeemed?
        "Reward Redeemed - Card Complete!"
      elsif card.completed?
        "Card Complete - Ready to Redeem!"
      else
        "Active Card - #{card.punches_count} out of 10 punches"
      end
    end
end
