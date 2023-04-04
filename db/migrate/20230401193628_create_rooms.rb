class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :token, null: false, default: ""
      t.string :name, null: false, default: ""
      t.integer :max_players, null: false, default: 16
      t.string :password, null: false, default: ""
      t.boolean :public, null: false, default: false
      t.references :created_by, null: false, foreign_key: { to_table: :players }

      t.timestamps
    end
  end
end
