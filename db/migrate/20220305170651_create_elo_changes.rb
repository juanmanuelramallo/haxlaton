class CreateEloChanges < ActiveRecord::Migration[7.0]
  def change
    create_table :elo_changes do |t|
      t.references :match, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.integer :value, null: false

      t.timestamps
    end
  end
end
