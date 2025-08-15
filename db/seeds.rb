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
  street:          "1133 West Main Street",  # Added proper street address
  city:            "Troy",
  state:           "OH",
  zip_code:        "45373",
  phone:           "937-703-1371",
  email:           "troylafiestaexpress@gmail.com",
  logo_url:        "https://lafiestaexpress.s3.us-east-2.amazonaws.com/cleanXpressLogo.png",
  monday_hours:    "11:00 AM – 9:30 PM",  # Fixed typo: mondaay_hours -> monday_hours
  tuesday_hours:   "11:00 AM – 9:30 PM",
  wednesday_hours: "11:00 AM – 9:30 PM",
  thursday_hours:  "11:00 AM – 9:30 PM",
  friday_hours:    "11:00 AM – 10:00 PM",
  saturday_hours:  "11:00 AM – 10:00 PM",
  sunday_hours:    "11:00 AM – 9:00 PM"
)

# Clear existing data
Customization.delete_all
MenuItem.delete_all
Category.delete_all

# Create Categories
categories = {
  "Tacos" => {
    description: "Traditional Mexican tacos with various fillings.",
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/taco_beef_1.jpeg"
  },
  "Street Tacos" => {
    description: "Authentic street-style tacos with fresh ingredients.",
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/street_taco_1.jpeg"
  },
  "Burritos" => {
    description: "Large flour tortillas filled with rice, beans, salsa, cheese, and your choice of protien.",
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/burrito_1.jpeg"
  },
  "Quesadillas" => {
    description: "Grilled tortillas with melted cheese and optional Add-ins.",
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/ques_1.jpeg"
  },
  "Nachos" => {
    description: "Crispy tortilla chips topped with cheese, salsa and your favorite toppings.",
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/nachos_1.jpeg"
  },
  "Sides" => {
    description: "Make it a meal with our delicious sides.",
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/mexican_rice_1.jpeg"
  },
  "Drinks" => {
    description: "Refreshing beverages.",
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/horchata_1.jpeg"
  },
  "Kids Meals" => {
    description: "Fun Tasty Favorites.",
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/kids_tacos_1.jpeg"
  }
}

category_records = {}
categories.each do |name, attributes|
  category_records[name] = Category.create!(
    name: name,
    description: attributes[:description],
    image_url: attributes[:image_url]
  )
end

# Create Menu Items
menu_items = [
  {
    name: "Taco",
    description: "Soft or crispy taco with your choice of meat, lettuce, cheese, and salsa.",
    price: 2.49,
    category: category_records["Tacos"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/taco_beef_1.jpeg"
  },
  {
    name: "Birria Taco",
    description: "Slow-cooked beef birria taco served with consommé.",
    price: 4.50,
    category: category_records["Tacos"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/birria_tacos_1.jpeg"
  },
  {
    name: "Street Taco",
    description: "Authentic Mexican street taco with your choice of meat.",
    price: 4.00,
    category: category_records["Street Tacos"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/street_taco_1.jpeg"
  },
  {
    name: "Burrito",
    description: "Burrito filled with beans, rice, salsa, and choice of protien.",
    price: 6.99,
    category: category_records["Burritos"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/burrito_1.jpeg"
  },
  {
    name: "Quesadilla",
    description: "Grilled tortilla with melted cheese and optional fillings.",
    price: 5.49,
    category: category_records["Quesadillas"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/ques_1.jpeg"
  },
  {
    name: "Bola",
    description: "Burrito in a Bowl with your choice of protein.",
    price: 6.99,
    category: category_records["Burritos"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/bola_1.jpeg"
  },
  {
    name: "Nachos",
    description: "Crispy tortilla chips served with warm cheese dip.",
    price: 5.99,
    category: category_records["Nachos"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/nachos_1.jpeg"
  },
  {
    name: "Chips with Salsa",
    description: "Crispy tortilla chips served with fresh salsa.",
    price: 2.50,
    category: category_records["Nachos"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/chips_salsa_1.jpeg"
  },
  {
    name: "Chips with Salsa and Cheese Dip",
    description: "Crispy tortilla chips served with both salsa and cheese dip.",
    price: 4.50,
    category: category_records["Nachos"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/chips_salsa_1.jpeg"
  },
  {
    name: "Bag of Chips",
    description: "A bag of our crispy tortilla chips.",
    price: 2.00,
    category: category_records["Sides"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/chips_salsa_1.jpeg"
  },
  {
    name: "Horchata",
    description: "Traditional Mexican rice water drink.",
    price: 2.25,
    category: category_records["Drinks"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/horchata_1.jpeg"
  },
  {
    name: "Ground Beef Taco (Kids)",
    description: "Kid-sized ground beef taco.",
    price: 3.25,
    category: category_records["Kids Meals"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/kids_tacos_1.jpeg"
  },
  {
    name: "Cheese Quesadilla (Kids)",
    description: "Kid-sized cheese quesadilla.",
    price: 3.25,
    category: category_records["Kids Meals"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/ques_1.jpeg"
  },
  {
    name: "Ground Beef Mini Burrito (Kids)",
    description: "Kid-sized ground beef burrito.",
    price: 3.25,
    category: category_records["Kids Meals"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/kids_beef_burrito_1.jpeg"
  },
  {
    name: "Mexican Rice",
    description: "Fluffy Mexican-style rice.",
    price: 1.75,
    category: category_records["Sides"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/mexican_rice_1.jpeg"
  },
  {
    name: "Refried Beans",
    description: "Creamy refried beans.",
    price: 1.75,
    category: category_records["Sides"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/refried_beans_1.jpeg"
  },
  {
    name: "Black Beans",
    description: "Seasoned black beans.",
    price: 1.75,
    category: category_records["Sides"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/black_beans_1.jpeg"
  },
  {
    name: "White Rice",
    description: "Steamed white rice.",
    price: 1.75,
    category: category_records["Sides"],
    image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/white_rice_1.jpeg"
  }
]

menu_item_records = {}
menu_items.each do |item|
  menu_item_records[item[:name]] = MenuItem.create!(
    name: item[:name],
    description: item[:description],
    price: item[:price],
    category: item[:category],
    image_url: item[:image_url]
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
    menu_item: menu_item_records["Burrito"],
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
  },
  {
    menu_item: menu_item_records["Nachos"],
    name: "Add Beef",
    price_adjustment: 0.30
  },
  {
    menu_item: menu_item_records["Street Taco"],
    name: "Add Al Pastor",
    price_adjustment: 0.30
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


resto = RestaurantInfo.find_or_initialize_by(name: "La Fiesta Express")

# Set or update the attributes
resto.assign_attributes(
  street:          "1133 West Main Street",
  city:            "Troy",
  state:           "OH",
  zip_code:        "45373",
  phone:           "937-703-1371",
  email:           "troylafiestaexpress@gmail.com",
  logo_url:        "https://lafiestaexpress.s3.us-east-2.amazonaws.com/cleanXpressLogo.png",
  monday_hours:    "11:00 AM – 9:30 PM",
  tuesday_hours:   "11:00 AM – 9:30 PM",
  wednesday_hours: "11:00 AM – 9:30 PM",
  thursday_hours:  "11:00 AM – 9:30 PM",
  friday_hours:    "11:00 AM – 10:00 PM",
  saturday_hours:  "11:00 AM – 10:00 PM",
  sunday_hours:    "11:00 AM – 9:00 PM"
)

# Clear existing banner photos
BannerPhoto.delete_all

# Create Banner Photos
banner_photos = [
  { image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/bannerPhotos/logophoto.png" },
  { image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/bannerPhotos/avaCrew.jpeg" },
  { image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/bannerPhotos/harritos.jpeg" },
  { image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/bannerPhotos/hotplate.jpeg" },
  { image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/bannerPhotos/diana.jpeg" },
  { image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/bannerPhotos/logophoto.png" },
  { image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/bannerPhotos/outsidetaco.jpeg" },
  { image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/bannerPhotos/titoAva.jpeg" },
  { image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/bannerPhotos/logophoto.png" },
  { image_url: "https://lafiestaexpress.s3.us-east-2.amazonaws.com/bannerPhotos/yancar.jpeg" }
]

banner_photos.each do |photo|
  BannerPhoto.create!(photo)
end
