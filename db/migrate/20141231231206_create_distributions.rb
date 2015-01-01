class CreateDistributions < ActiveRecord::Migration
  def change
    create_table :distributions do |t|
      t.text :description
      t.integer :minutes
      t.string :image

      t.timestamps null: false
    end
    add_index :distributions, :minutes
  end
end
