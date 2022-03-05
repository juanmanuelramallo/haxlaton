class AddMatchPlayerToEloChanges < ActiveRecord::Migration[7.0]
  def change
    change_table :elo_changes do |t|
      t.references :match_player, foreign_key: true
      t.remove_references :match, foreign_key: true
      t.remove_references :player, foreign_key: true
    end
  end
end
