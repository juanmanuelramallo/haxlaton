FactoryBot.define do
  factory :room do
    token { "random-token" }
    name { "Oke oke" }
    max_players { 16 }
    password { "" }
    public { true }
    association :created_by, factory: :player
  end
end
