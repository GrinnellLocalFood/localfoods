# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment_notification do
    params "MyText"
    cart_id 1
    status "MyString"
    transaction ""
  end
end
