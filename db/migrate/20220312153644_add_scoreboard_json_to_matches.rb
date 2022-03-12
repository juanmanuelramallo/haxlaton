class AddScoreboardJsonToMatches < ActiveRecord::Migration[7.0]
  def change
    add_column :matches, :scoreboard, :json
  end
end
