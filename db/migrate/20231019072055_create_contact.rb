class CreateContact < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.string :name
      t.string :country
      t.string :province
      t.string :city
      t.string :town
      t.string :address
      t.string :postcode
      t.string :phone
      t.string :remark
      t.boolean :active, default: true
      t.boolean :is_default, default: false

      t.timestamps
    end
  end
end
