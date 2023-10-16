class CreateUserSigninLogJob < ApplicationJob
  def perform(params)
    SessionService.create_signin_log(params)
  end
end
