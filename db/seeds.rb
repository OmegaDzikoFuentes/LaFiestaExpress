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

# — Categories
entrees = Category.create!(name: "Entrees",   description: "Our signature main dishes")
sides   = Category.create!(name: "Sides",     description: "Add-ons & extras")
drinks  = Category.create!(name: "Beverages", description: "Cold drinks & aguas frescas")

# — Menu Items
burrito = MenuItem.create!(
  name:        "Burritos",
  description: "Choice of meat | beans | rice | salsa | cheese | sour cream",
  price:       6.99,
  image_url:   "https://example.com/images/burrito.jpg",
  category:    entrees
)

torta = MenuItem.create!(
  name:        "Tortas",
  description: "Mexican sandwich | choice of meat | lettuce | tomatoes | onions | cheese | sour cream",
  price:       6.99,
  category:    entrees
)

quesadilla = MenuItem.create!(
  name:        "Quesadilla",
  description: " "12" flour tortilla | cheese | choice of meat | lettuce | tomatoes | sour cream",
  price:       5.49,
  category:    entrees
)

tacos = MenuItem.create!(
  name:        "Tacos",
  description: "Hard or soft shells | choice of meat | lettuce | tomatoes | cheese",
  price:       2.49,
  category:    entrees
)

bowl = MenuItem.create!(
  name:        "Bola (Burrito Bowl)",
  description: "Burrito in a bowl | choice of meat | beans | salsa | rice | cheese | sour cream",
  price:       6.99,
  category:    entrees
)

nachos = MenuItem.create!(
  name:        "Nachos",
  description: "Corn chips | choice of meat | beans | cheese | sour cream | lettuce | tomatoes",
  price:       5.99,
  category:    entrees
)

fiesta_salad = MenuItem.create!(
  name:        "Fiesta Salad",
  description: "Romaine & iceberg | choice of meat | beans | pico de gallo | cheese | sour cream | dressing",
  price:       6.99,
  category:    entrees
)

refresco = MenuItem.create!(
  name:        "Refresco (Soft Drink)",
  description: "Bottled soda",
  price:       2.25,
  category:    drinks
)

horchata = MenuItem.create!(
  name:        "Horchata (Rice Water)",
  description: "Traditional sweet rice drink",
  price:       2.25,
  category:    drinks
)

# — Sides & Extras
rice = MenuItem.create!(
  name:        "Mexican Rice",
  description: "Authentic seasoned rice",
  price:       1.75,
  category:    sides
)

white_rice = MenuItem.create!(
  name:        "White Rice",
  description: "Plain steamed white rice",
  price:       1.75,
  category:    sides
)

beans = MenuItem.create!(
  name:        "Beans (your choice)",
  description: "Black or pinto beans",
  price:       1.75,
  category:    sides
)

# — Customizations (applied to Entrees)
meats = %w[Barbacoa Carne\ Asada Al\ Pastor Carnitas Pollo Carne\ Molida]
entree_items = [burrito, tacos, bowl, fiesta_salad, torta, quesadilla, nachos]

entree_items.each do |item|
  meats.each do |meat|
    Customization.create!(
      menu_item:        item,
      name:             meat,
      price_adjustment: 0.30
    )
  end
end

# Extras
extras = {
  "Extra cheese" => 0.99,
  "Jalapeños"    => 0.75,
  "Sour cream"   => 0.99,
  "Avocado"      => 1.45,
  "Guacamole"    => 1.45
}

entree_items.each do |item|
  extras.each do |extra_name, price|
    Customization.create!(
      menu_item:        item,
      name:             extra_name,
      price_adjustment: price
    )
  end
end

# — Create a demo user
User.create!(
  first_name: "Demo",
  last_name:  "Customer",
  username:   "demo_user",
  email:      "demo@lafiesta.com",
  phone:      "937-000-0000",
  password_digest: BCrypt::Password.create("password")  
)

puts "✅ Seed data loaded successfully!"