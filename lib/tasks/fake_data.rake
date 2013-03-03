namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    require 'faker'
    Rake::Task['db:reset'].invoke
    create_admin
    make_producers
    make_items
    add_photos_to_items
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
  User.create!(:first_name => first_name,
   :last_name => last_name,
   :email => email,
   :password => password,
   :password_confirmation => password,
   :admin => admin,
   :coordinator => coordinator,
   :producer => producer)
end

def make_producers
  5.times do |n|
    first_name  = Faker::Name.name
    last_name = Faker::Name.name
    email = Faker::Internet.email
    password  = "password"
    producer = true
    @user = User.create!(:first_name => first_name,
     :last_name => last_name,
     :email => email,
     :password => password,
     :password_confirmation => password,
     :producer => producer)

  end
end

def make_items
  User.all.each do |user|
    if user.producer
    20.times do |i|
      name = Faker::Name.name
      description = Faker::Lorem.sentences(2)
      minorder = rand(100)
      maxorder = minorder + rand(100)
      price = rand(1000)
      available = (rand(2) > 1) ? true : false
      category_id = Category.find_by_name("Other").id
      inventory_id = user.inventory.id
      Item.create!(:name => name, 
        :description => description,
        :minorder => minorder,
        :maxorder => maxorder,
        :price => price,
        :available => available,
        :category_id => category_id,
        :inventory_id => inventory_id)
    end
  end
end
end

def add_photos_to_items
  Item.all.each {|item| item.photo = File.open(Dir.glob(File.join(Rails.root, 'sampleimages', '*')).sample);item.save}
end