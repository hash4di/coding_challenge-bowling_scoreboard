class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :score, default: 0, null: false
      t.string :frames, default: nil, limit: 1024

      t.timestamps
    end
  end
end
