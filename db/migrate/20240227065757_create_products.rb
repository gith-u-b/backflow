class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.integer :user_id
      t.integer :shop_id
      t.string :name
      t.string :description
      t.decimal :price, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
