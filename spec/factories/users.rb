FactoryBot.define do
  factory :user do
    username { Faker::Name.name }
    password { Faker::PhoneNumber.cell_phone }
  end
end
