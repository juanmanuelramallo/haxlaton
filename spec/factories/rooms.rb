FactoryBot.define do
  factory :room do
    token { "MyString" }
    room_name { "MyString" }
    max_players { 1 }
    password { "MyString" }
    public { false }
  end
end
