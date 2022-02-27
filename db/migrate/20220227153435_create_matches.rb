class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|

      t.timestamps
    end
  end
end
