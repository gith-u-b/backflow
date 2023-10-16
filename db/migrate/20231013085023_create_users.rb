class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username 
      t.string :password_digest
      t.string :nickname 
      t.string :sign
      t.string :api_token 
      t.boolean :is_admin, default: false 
      t.integer :signin_count, default: 0
      t.datetime :current_signin_at 
      t.string :current_signin_ip
      t.datetime :last_signin_at
      t.string :last_signin_ip
      t.string :create_ip
      t.string :create_ip_country
      t.string :create_ip_province
      t.string :create_ip_city
      t.integer :current_conins, default:0
      t.boolean :is_enabled, default: true
      t.string :promo_code
      t.integer :promo_users_count
      t.integer :promo_user_id
      t.integer :binded_promo_code

      t.timestamps
    end
  end
end
