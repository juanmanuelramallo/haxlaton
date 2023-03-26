class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :match_player, null: false, foreign_key: true
      t.string :body, default: "", null: false
      t.timestamp :sent_at, null: false

      t.timestamps
    end
  end
end
