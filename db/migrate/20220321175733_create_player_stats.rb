class CreatePlayerStats < ActiveRecord::Migration[7.0]
  def change
    create_table :player_stats do |t|
      t.integer :goals, default: 0, null: false
      t.integer :assists, default: 0, null: false
      t.integer :own_goals, default: 0, null: false
      t.references :match_player, foreign_key: true

      t.timestamps
    end

    add_column :matches, :winner_team_id, :integer
  end
end
