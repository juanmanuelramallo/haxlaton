FactoryBot.define do
  factory :match_player do
    match
    player
    team_id { 1 }
  end
end
