# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :purchase do
    user_id ""
    item_id ""
    quantity ""
    unit_price ""
  end
end
