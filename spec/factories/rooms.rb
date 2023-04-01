FactoryBot.define do
  factory :room do
    api_key { "MyString" }
    room_name { "MyString" }
    max_players { 1 }
    password { "MyString" }
    public { false }
  end
end
