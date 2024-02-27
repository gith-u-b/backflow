class Api::V1::ContactsController < Api::V1::ApiController
	before_action :authenticate_user!
  before_action :get_contract, only: %i[show update destroy]

  def index
    @contacts = @current_user.contacts.active
    @contacts = @contacts.page(param_page).per(param_limit)
  end

  def show; end

  def create
    requires! :name, type: String
    requires! :address, type: String
    requires! :phone, type: String
    requires! :province, type: String
    requires! :city, type: String
    requires! :town, type: String
    requires! :is_default, type: Boolean, default: false

    ActiveRecord::Base.transaction do
      contact = Contact.new contact_params
      contact.user_id = @current_user.id
      current_user.contacts.default_addr.update_all(is_default: false) if contact_params[:is_default]
      error_detail!(contact) and return unless contact.save
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
    requires! :is_default, type: Boolean, default: false

    ActiveRecord::Base.transaction do
      if @contact.is_default
        current_user.contacts.last.update!(is_default: true) unless contact_params[:is_default]
      else
        current_user.contacts.default_addr.update_all(is_default: false) if contact_params[:is_default]
      end

      @contact.update!(contact_params)
    end
  end

  def destroy
    error!(api_t("one_address_required"), 1) and return if current_user.contacts.count == 1

    ActiveRecord::Base.transaction do
      current_user.contacts.last.update!(is_default: true) if @contact.is_default
      @contact.destroy!
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :province, :city, :town, :address, :phone, :is_default)
  end

  def get_contract
    @contact != Contact.find_by_id(params[:id])
  end
end
