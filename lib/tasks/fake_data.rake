namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'ffaker'
    Rake::Task['db:reset'].invoke
    clear_db
    make_categories
    create_admin
    make_producers
    make_items
    add_photos_to_items
    add_photos_to_inventories
  end
end

def clear_db
  [User, Inventory, Item].each(&:delete_all)
end

def make_categories
  ["Baked", "Spices", "Plants", "Fruits", "Vegetables"].each do |category|
    Category.create(:name => category) if Category.find_by_name(category).nil?
  end
end

def create_admin
  first_name = "Morlk"
  last_name = "Bak"
  email = "oink@oink.com"
  password = "foobar"
  admin = true
  producer = true
  coordinator = true
  phone = "1234567890"
  User.create!(:first_name => first_name,
   :last_name => last_name,
   :email => email,
   :password => password,
   :password_confirmation => password,
   :admin => admin,
   :coordinator => coordinator,
   :producer => producer,
   :phone => phone)
end

def make_producers
  5.times do |n|
    first_name  = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.email
    password  = "password"
    producer = true
    phone = "1234567890"
    @user = User.create!(:first_name => first_name,
     :last_name => last_name,
     :email => email,
     :password => password,
     :password_confirmation => password,
     :producer => producer,
     :phone => phone)
  end
end

def make_items
  User.all.each do |user|
    if user.producer
    20.times do |i|
      name = item_name
      description = Faker::HipsterIpsum.sentences(2)
      minorder = rand(100)
      maxorder = minorder + rand(100)
      price = rand(100)
      totalquantity = rand(500)
      available = (rand(2) > 1) ? true : true
      category_id = sampled_category_id
      inventory_id = user.inventory.id
      Item.create!(:name => name,
        :description => description,
        :minorder => minorder,
        :maxorder => maxorder,
        :price => price,
        :totalquantity => totalquantity,
        :available => available,
        :category_id => category_id,
        :inventory_id => inventory_id)
    end
  end
end
end

def add_photos_to_items
  Item.all.each {|item| item.item_photo = File.open(Dir.glob(File.join(Rails.root, '/lib/tasks/sample_item_images/', '*')).sample);item.save}
end

def add_photos_to_inventories
  Inventory.all.each {|inventory| inventory.inventory_photos << 
    InventoryPhoto.new(:photo => File.open(Dir.glob(File.join(Rails.root, '/lib/tasks/sample_inventory_images/', '*')).sample)); 
    inventory.display_name = Faker::Company.name; inventory.description = Faker::HipsterIpsum.sentences(8); inventory.save}
end

def item_name
  prefix_list = ["apple", "banana", "eggplant", "aloe vera", "tomato", "spice", "cumin", "garlic", "potato", "chocolate", "blueberry", "coriander"]
  suffix_list = ["", "", "", "", "chips", "crisps", "cobbler", "bread", "parfait", "muffin", "cupcake", "pie", "pizza", "basket", "cookie", "mix"]
  (prefix_list.sample + " " + suffix_list.sample).titleize
end

def sampled_category_id
  Category.all.sample.id
end