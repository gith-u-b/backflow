module Utils
  # Symmetric-key algorithm
  class AesEncrypt
    def self.encrypt(string, key)
      ::AesCrypt.encrypt(string, key).strip
    end

    def self.decrypt(string, key)
      ::AesCrypt.decrypt(string, key)
    end
  end

  class Numeric
    def percent_of(n)
      self.to_f / n.to_f * 100.0
    end
  end

  def self.valid_password?(pwd)
    (/[^A-Za-z0-9~!@#$%^&*()]+/ =~ pwd) == nil
  end

  def self.valid_email?(email)
    (/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i =~ email) == nil
  end

  module Gen
    def self.friendly_token(length = 20)
      rlength = (length * 3) / 4
      SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
    end
  end
end
