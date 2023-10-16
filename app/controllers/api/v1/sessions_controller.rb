class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_action :authenticate_user!

  def create
    requires! :username, type: String
    requires! :password, type: String

    @client_ip = client_ip
    @ip_region = client_ip_region
    user = User.find_by(username: allowed_params[:username])
    error!(api_t("user_does_not_exist"), 1) and return if user.blank?
    error!(api_t("invalid_username_or_password"), 2) and return if !user.authenticate(allowed_params[:password])
    error!(api_t("username_is_disable"), 3) and return if !user.is_enabled?
    after_signin(user)
  end

  private

  def after_signin(user)
    @user = user
    @user.sign_in(@client_ip)
    @token = create_jwt(@user)
    SessionService.signin_log_perform_later(
      @user.id,
      @client_ip,
      @ip_region
    )
  end

  def allowed_params
    params.permit(:username, :password)
  end
end