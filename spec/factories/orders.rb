# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    origin "Kolla Space Sabang"
    destination "Pasaraya Blok M"
    payment_type 'Cash'
    association :type
    association :user
  end

  factory :invalid_order, parent: :order do
    origin nil
    destination nil
    payment_type nil
  end
end