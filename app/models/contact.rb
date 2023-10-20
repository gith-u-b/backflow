class Contact < ApplicationRecord
	validates :name, presence: true, length: { maximum: 10 }
	validates :address, presence: true
  validates :phone, presence: true, format: { with: /\A1[3|4|5|7|8|9]\d{9}\z/ }

	validate :check_city_presence

	belongs_to :user

	scope :active, -> { where(active: true) }

  def check_city_presence
    if province.blank? && city.blank? && town.blank?
      errors.add(:base, '所在城区不能为空')
    end
  end

  def locations
    if province == city
      "#{self.city}#{self.town}"
    else
      "#{self.province}#{self.city}#{self.town}"
    end
  end
end
