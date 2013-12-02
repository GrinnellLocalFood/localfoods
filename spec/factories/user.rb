FactoryGirl.define do

  factory :user do |user|  
    user.first_name            "Michael"
    user.last_name       "Hartl"
    user.email                 "mhartl" + Random.rand(100000).to_s() + "@example.com"
    user.password              "foobar"
    user.password_confirmation "foobar"
    user.phone "123123123"
    user.after_build do |f|
      f.cart ||= Cart.create!(:user_id => f.id)
    end
  end

  factory :user_properties, class: User do
    first_name "Example"
    last_name "User"
    email "user@example.com" 
    phone "123123123"
    password "password"
    password_confirmation "password"
  end

  factory :user_producer, class: User do
    first_name "Example"
    last_name "User"
    email "user@example.com"
    password "password"
    password_confirmation "password"
    phone "123123123"
    producer true
  end

end
