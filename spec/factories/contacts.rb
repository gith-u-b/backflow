FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    address { Faker::Address.full_address }
    phone { Faker::PhoneNumber.cell_phone }
    province { Faker::Address.state }
    city { Faker::Address.city }
    town { Faker::Address.community }
    is_default { [0, 1].sample }

		user
  end
end
