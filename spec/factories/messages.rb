FactoryBot.define do
  factory :message do
    match_player { nil }
    body { "MyString" }
    sent_at { "2023-03-26 14:02:47" }
  end
end
