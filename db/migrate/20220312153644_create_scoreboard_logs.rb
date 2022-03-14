class CreateScoreboardLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :scoreboard_logs do |t|
      t.jsonb :data, null: false
      t.references :stored_from_match, foreign_key: {to_table: :matches}

      t.timestamps
    end
  end
end
