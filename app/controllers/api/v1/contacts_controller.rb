class Api::V1::ContactsController < Api::V1::ApiController
	def index
		@contacts = @current_user.contacts.active
		@contacts = @contacts.page(param_page).per(param_limit)
	end

	def show
    @contact = Contact.find(params[:id])
  end

	def create
    requires! :name, type: String
		requires! :address, type: String
		requires! :phone, type: String
		requires! :province, type: String
		requires! :city, type: String
		requires! :town, type: String
		requires! :is_default, type: Integer

		ActiveRecord::Base.transaction do
			contact = Contact.new(contact_params)
			contact.user_id = @current_user.id
			current_user.contacts.update_all(is_default: false) if contact_params[:is_default].present?
			error_detail!(contact) and return if !contact.save
			if current_user.contacts.count == 1
        current_user.contacts.first.update!(is_default: true)
      end
		end
	end

	def update
		requires! :name, type: String
		requires! :address, type: String
		requires! :phone, type: String
		requires! :province, type: String
		requires! :city, type: String
		requires! :town, type: String
		requires! :is_default, type: Integer

		@contact = Contact.find(params[:id])

		ActiveRecord::Base.transaction do
			if @contact.is_default?
				current_user.contacts.first.update!(is_default: true) if !contact_params[:is_default].present?
			else
				current_user.contacts.update_all(is_default: false) if contact_params[:is_default].present?
			end

			@contact.update!(contact_params)
		end
	end

	def destroy
		@contact = Contact.find(params[:id])
		error!(api_t("one_address_required"), 1) and return if current_user.contacts.count == 1

		ActiveRecord::Base.transaction do
			@contact.destroy!

			if @contact.is_default?
				current_user.contacts.first.update!(is_default: true)
			end
		end
	end

	private

	def contact_params
    params[:contact].permit(:id, :user_id, :name, :province, :city, :town, :address, :phone, :is_default)
  end
end
