class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.integer :user_id
      t.integer :contact_id
      t.integer :number

      t.timestamps
    end
  end
end
