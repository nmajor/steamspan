class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :game_name
      t.integer :appid
      t.integer :beat_time

      t.timestamps null: false
    end
    add_index :games, :game_name
    add_index :games, :appid
    add_index :games, :beat_time
  end
end
