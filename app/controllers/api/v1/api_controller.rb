class Api::V1::ApiController < ActionController::API
  helper ApplicationHelper
  include ActionView::Layouts

  layout 'api'

  helper_method :current_user
  helper_method :encrypt_string

  before_action :setup_layout_elements
  before_action :authenticate_user!

  class ParameterValueNotAllowed < ActionController::ParameterMissing
    attr_reader :values
    def initialize(param, values)
      @param = param
      @values = values
      super("参数#{param}的值只允许在#{values}以内")
    end
  end

  class ParameterDecryptFail < ActionController::ParameterMissing
    def initialize(param)
      @param = param
      super(param)
    end
  end

  class ParameterDecodeFail < ActionController::ParameterMissing
    def initialize(param)
      @param = param
      super(param)
    end
  end

  class ParameterValueNotAllowed < ActionController::ParameterMissing
    attr_reader :values
    def initialize(param, values)
      @param = param
      @values = values
      super("参数#{param}的值只允许在#{values}以内")
    end
  end

  class AccessDenied < StandardError; end
  class PageNotFound < StandardError; end
  class UserIsDisabled < StandardError; end
  class UserIsNonExistent < StandardError; end

  rescue_from(ActionController::ParameterMissing) do |err|
    render json: { success: false, error: 'ParameterInvalid', message: "参数#{err.param}未提供或为空" }, status: 200
  end
  rescue_from(ActiveRecord::RecordInvalid) do |err|
    render json: { success: false, error: 'RecordInvalid', message: err }, status: 400
  end
  rescue_from(AccessDenied) do |err|
    render json: { success: false, error: 'AccessDenied', message: err }, status: 403
  end
  rescue_from(ActiveRecord::RecordNotFound) do
    render json: { success: false, error: 'ResourceNotFound', message: '记录未找到' }, status: 404
  end
  rescue_from(ActiveRecord::RecordNotUnique) do
    render json: { success: false, error: 'ResourceNotUnique', message: '资源不是唯一' }, status: 400
  end
  rescue_from(ParameterDecryptFail) do |err|
    render json: { success: false, error: 'ParameterDecryptFail', message: "参数#{err.param}解密失败" }, status: 400
  end
  rescue_from(ParameterDecodeFail) do |err|
    render json: { success: false, error: 'ParameterDecodeFail', message: "参数#{err.param}解码失败" }, status: 400
  end

  def setup_layout_elements
    @success = true
    @message = nil
  end

  def current_user
    @current_user
  end

  def param_page
    params[:page] || 1
  end

  def param_limit
    result = params[:limit] || 25
    result = 50 if result.to_i > 50
    result
  end

  def client_ip
    # 首先获取 X_REAL_IP，如果开头为10，或者为共享地址，则获取CDN_SRC_IP
    # 如果还是为空(本地开发环境)，则获取remote_ip
    result = request.headers["HTTP_X_REAL_IP"]&.split(',')&.first
    if result.blank? || Utils::IP.is_private_ip?(result)
      result = request.headers["HTTP_CDN_SRC_IP"]
    end
    result = request.remote_ip if result.blank?
    result
  end

  def client_ip_region
    Ipnet.find_by_ip(client_ip)
  end

  # 设置必选参数
  def requires!(name, opts = {})
    opts[:require] = true
    optional!(name, opts)
  end

  # 设置非必选参数
  def optional!(name, opts = {})
    if params[name].blank? && opts[:require] == true
      raise ActionController::ParameterMissing.new(name)
    end

    if opts[:values] && params[name].present?
      values = opts[:values].to_a
      if !values.include?(params[name]) && !values.include?(params[name].to_i)
        raise ParameterValueNotAllowed.new(name, opts[:values])
      end
    end

    if params[name].blank? && opts[:default].present?
      params[name] = opts[:default]
    end
  end

  def api_t(key)
    I18n.t("api.#{key}")
  end

  # 返回错误信息
  def error!(msg, code = nil)
    @success = false
    @message = msg
    json = { success: @success, message: @message }
    json[:error_code] = code if code.present?
    render json: json
  end

  # 显示详细错误信息
  def error_detail!(obj, code = nil)
    @success = false
    message = obj.errors.messages.first
    if message.present?
      if message.count > 1
        @message = message.last.first
      else
        @message = message
      end
    else
      @message = '请求失败'
    end
    json = { success: @success, message: @message }
    json[:error_code] = code if code.present?
    render json: json
  end

  def encrypt_string(text)
    return nil if text.blank?
    Utils::AesEncrypt.encrypt(text, CONFIG.client_secret_key)
  end

  # 创建客户端API访问Token
  def create_jwt(user)
    payload = { id: user.id, username: user.username }
    JWT.encode(payload, user.api_token)
  end

  # 根据headers认证用户
  def authenticate_user!
    auth_jwt!
    rescue JWT::ExpiredSignature
      error!('令牌过期', 101)
    rescue JWT::VerificationError
      error!('令牌验证错误', 101)
    rescue JWT::DecodeError
      error!('令牌非法', 101)
    rescue JWT::InvalidIssuerError
      error!(e, 101)
    rescue UserIsDisabled
      error!(api_t("user_has_been_disabled"), 102)
    rescue UserIsNonExistent
      error!(api_t("user_does_not_exist"), 101)
  end
 
  def auth_jwt!
    jwt = request.headers['HTTP_AUTHORIZATION']&.split(' ')&.last
    raise JWT::VerificationError.new if jwt.blank?
    # 读取令牌携带用户信息，此处不作令牌的验证，不会抛出异常
    payload, header = JWT.decode(jwt, nil, false, verify_expiration: true)
    user = ::User.find_by(id: payload['id'])
    # 获取验证令牌的密钥
    secret_key = user ? user.api_token : ''
    # 用秘钥验证令牌，会抛出 JWT::ExpiredSignature 或 JWT::DecodeError 异常
    payload, header = JWT.decode(jwt, secret_key)
    # 验证成功，设置当前用户
    @current_user = user
  end
end
