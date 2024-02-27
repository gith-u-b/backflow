class CreateShops < ActiveRecord::Migration[7.0]
  def change
    create_table :shops do |t|
      t.integer :company_id
      t.string :name
      t.string :address
      t.string :description

      t.timestamps
    end
  end
end
