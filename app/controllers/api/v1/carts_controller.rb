class Api::V1::CartsController < Api::V1::ApiController
	def index
		@cart = Cart.where(user_id: @current_user.id).first_or_create
		@result = {shop_cart_groups: [], total_price: 0}
		cart_items = @cart.cart_items.includes(:shop, :product)

		cart_items.group_by(&:shop).each do |shop, shop_items|
			@result[:shop_cart_groups] << shop_items_group_attrs(shop, shop_items)
		end
	end

	def destroy
		@cart = @current_user.cart
		@cart.cart_items.find(params[:id]).destroy
	end

	def clear_cart
		@cart = @current_user.cart
		@cart.cart_items.selected.destroy_all
	end

	private

	def shop_items_group_attrs(shop, shop_items)
		attrs = {id: shop&.id, name: shop&.name, products: []}
		attrs[:products] = shop_items.as_json(CartItem::Api.list_json_options)
		attrs
	end
end