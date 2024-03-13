FactoryBot.define do
  factory :user do
    username { "testuser1" }
    password { "testpassword1" }
  end

  factory :disabe_user, class: User do
    username { "testuser2" }
    password { "testpassword2" }
    is_enabled { false }
  end
end
