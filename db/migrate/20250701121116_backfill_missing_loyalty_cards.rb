class BackfillMissingLoyaltyCards < ActiveRecord::Migration[8.0]
  def up
    User.find_each do |user|
      if user.loyalty_cards.none?
        user.loyalty_cards.create!(
          punches_count: 0,
          discount_amount: 8.00
        )
      end
    end
  end

  def down
    # Can't reverse this data migration
  end
end
