FactoryBot.define do
  factory :player do
    name { Faker::Name.name }
    password { "password" }
  end
end
