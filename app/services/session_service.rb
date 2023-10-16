class SessionService
  def self.signin_log_perform_later(user_id, remote_ip, ip_region)
    signin_log_params = {
      user_id: user_id,
      remote_ip: remote_ip,
      ip_country: ip_region[:country],
      ip_province: ip_region[:province],
      ip_city: ip_region[:city]
    }
    CreateUserSigninLogJob.perform_later(signin_log_params)
  end

  def self.create_signin_log(params)
    UserSigninLog.create(
      user_id: params[:user_id],
      ip: params[:remote_ip],
      ip_country: params[:ip_country],
      ip_province: params[:ip_province],
      ip_city: params[:ip_city]
    )
  end
end
