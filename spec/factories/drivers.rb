# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :driver do
    sequence :external_id do |n|
      n
    end
    full_name { Faker::Name.first_name }
  end
end
