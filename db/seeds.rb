# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# — Restaurant Info
resto = RestaurantInfo.create!(
  name:            "La Fiesta Express",
  street:          "123 Main Street",  # Added proper street address
  city:            "Troy",
  state:           "OH",
  zip_code:        "45373",
  phone:           "937-703-1371",
  email:           "info@lafiestatroy.com",
  logo_url:        "https://example.com/logo.png",
  monday_hours:    "10:00 AM – 8:00 PM",  # Fixed typo: mondaay_hours -> monday_hours
  tuesday_hours:   "10:00 AM – 8:00 PM",
  wednesday_hours: "10:00 AM – 8:00 PM",
  thursday_hours:  "10:00 AM – 8:00 PM",
  friday_hours:    "10:00 AM – 9:00 PM",
  saturday_hours:  "11:00 AM – 9:00 PM",
  sunday_hours:    "11:00 AM – 6:00 PM"
)

# Clear existing data
Customization.delete_all
MenuItem.delete_all
Category.delete_all

# Create Categories
categories = {
  "Tacos" => "Traditional Mexican tacos with various fillings.",
  "Burritos" => "Large flour tortillas filled with your choice of ingredients.",
  "Quesadillas" => "Grilled tortillas with melted cheese and optional fillings.",
  "Nachos" => "Crispy tortilla chips topped with cheese and other toppings.",
  "Sides" => "Complementary side dishes.",
  "Drinks" => "Refreshing beverages.",
  "Kids Meals" => "Smaller portions for children."
}

category_records = {}
categories.each do |name, description|
  category_records[name] = Category.create!(
    name: name,
    description: description,
    image_url: nil
  )
end

# Create Menu Items
menu_items = [
  {
    name: "Birria Taco",
    description: "Slow-cooked beef birria taco served with consommé.",
    price: 4.75,
    category: category_records["Tacos"]
  },
  {
    name: "Street Taco",
    description: "Authentic Mexican street taco with your choice of meat.",
    price: 3.50,
    category: category_records["Tacos"]
  },
  {
    name: "Drunken Burrito",
    description: "Burrito smothered in our special sauce.",
    price: 9.50,
    category: category_records["Burritos"]
  },
  {
    name: "Quesadilla",
    description: "Grilled tortilla with melted cheese and optional fillings.",
    price: 9.00,
    category: category_records["Quesadillas"]
  },
  {
    name: "Bola",
    description: "A delicious mix of meats and toppings wrapped in a tortilla.",
    price: 11.50,
    category: category_records["Burritos"]
  },
  {
    name: "Chips with Cheese Dip",
    description: "Crispy tortilla chips served with warm cheese dip.",
    price: 4.50,
    category: category_records["Nachos"]
  },
  {
    name: "Chips with Salsa",
    description: "Crispy tortilla chips served with fresh salsa.",
    price: 2.50,
    category: category_records["Nachos"]
  },
  {
    name: "Chips with Salsa and Cheese Dip",
    description: "Crispy tortilla chips served with both salsa and cheese dip.",
    price: 5.50,
    category: category_records["Nachos"]
  },
  {
    name: "Bag of Chips",
    description: "A bag of our crispy tortilla chips.",
    price: 2.00,
    category: category_records["Sides"]
  },
  {
    name: "Horchata",
    description: "Traditional Mexican rice water drink.",
    price: 2.25,
    category: category_records["Drinks"]
  },
  {
    name: "Ground Beef Taco (Kids)",
    description: "Kid-sized ground beef taco.",
    price: 3.25,
    category: category_records["Kids Meals"]
  },
  {
    name: "Cheese Quesadilla (Kids)",
    description: "Kid-sized cheese quesadilla.",
    price: 3.25,
    category: category_records["Kids Meals"]
  },
  {
    name: "Ground Beef Mini Burrito (Kids)",
    description: "Kid-sized ground beef burrito.",
    price: 3.25,
    category: category_records["Kids Meals"]
  }
]

menu_item_records = {}
menu_items.each do |item|
  menu_item_records[item[:name]] = MenuItem.create!(
    name: item[:name],
    description: item[:description],
    price: item[:price],
    category: item[:category],
    image_url: nil
  )
end

# Create Customizations
customizations = [
  {
    menu_item: menu_item_records["Birria Taco"],
    name: "Extra Cheese",
    price_adjustment: 0.99
  },
  {
    menu_item: menu_item_records["Street Taco"],
    name: "Add Guacamole",
    price_adjustment: 1.45
  },
  {
    menu_item: menu_item_records["Drunken Burrito"],
    name: "Add Sour Cream",
    price_adjustment: 0.99
  },
  {
    menu_item: menu_item_records["Quesadilla"],
    name: "Add Jalapeños",
    price_adjustment: 0.75
  },
  {
    menu_item: menu_item_records["Bola"],
    name: "Add Avocado",
    price_adjustment: 1.45
  }
]

customizations.each do |customization|
  Customization.create!(
    menu_item: customization[:menu_item],
    name: customization[:name],
    price_adjustment: customization[:price_adjustment],
    is_default: false
  )
end
