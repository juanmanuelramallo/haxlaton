namespace :backfill_messages do
  desc "Backfill messages with match and player"
  task :match_and_player => :environment do
    Message.where(match: nil, player: nil).find_each do |message|
      match_player = MatchPlayer.find(message.match_player_id)
      message.update(match: match_player.match, player: match_player.player)
      print "."
    end

    puts "Done"
  end
end
