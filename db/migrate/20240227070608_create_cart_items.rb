class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items do |t|
      t.integer :cart_id
      t.integer :product_id
      t.integer :shop_id
      t.string :product_name
      t.text :sku
      t.string :sku_key
      t.integer :number
      t.decimal :price, precision: 10, scale: 2, default: 0.0
      t.decimal :origin_price, precision: 10, scale: 2, default: 0.0
      t.string :prc
      t.boolean :is_selected, default: false

      t.timestamps
    end
    add_index :cart_items, :cart_id
    add_index :cart_items, :shop_id
  end
end
