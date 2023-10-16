json.token @token
json.extract! @user, :id, :username
json.created_at format_api_time(@user.created_at)
