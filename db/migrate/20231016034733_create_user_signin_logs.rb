class CreateUserSigninLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :user_signin_logs do |t|
      t.integer :user_id
      t.string :ip
      t.string :ip_country
      t.string :ip_province
      t.string :ip_city

      t.timestamps
    end
  end
end
