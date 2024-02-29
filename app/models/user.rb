class User < ApplicationRecord
  scope :admin, -> { where(is_admin: true) }

  has_many :contacts
  has_many :products
  has_many :user_signin_logs
  has_one :cart

  has_secure_token :api_token
  has_secure_password

  def sign_in(remote_ip)
    self.update_columns(
      signin_count: self.signin_count + 1,
      current_signin_at: Time.now,
      current_signin_ip: remote_ip,
      last_signin_at: self.current_signin_at,
      last_signin_ip: self.current_signin_ip
    )
  end
end
