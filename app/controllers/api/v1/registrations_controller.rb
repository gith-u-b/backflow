class Api::V1::RegistrationsController < Api::V1::ApiController
  skip_before_action :authenticate_user!

  def create
    requires! :username, type: String
    requires! :password, type: String
    requires! :confirmation_password, type: String

    @client_ip = client_ip
    @ip_region = client_ip_region
    username = allowed_params[:username].strip
    # 检查密码是否有效
    error!(api_t("invalid_password"), 1) and return if !Utils.valid_password?(allowed_params[:password])
    # 检查确认密码是否一样
    error!(api_t('password_is_not_match'), 2) and return if allowed_params[:password] != allowed_params[:confirmation_password]
    # 检查用户名是否有重复
    user = User.find_by(username: username)
    if user.present?
      error!(api_t('username_already_exist'), 3) and return
    end
    # 创建用户
    @user = User.create(
      username: username,
      password: allowed_params[:password]
    )
    after_signin(@user)
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
    params.permit(:username, :password, :confirmation_password)
  end
end
