class Product < ApplicationRecord
	belongs_to :user
	belongs_to :shop
	has_many :cart_items
end