class Shop < ApplicationRecord
	has_many :products
	has_many :cart_items
end