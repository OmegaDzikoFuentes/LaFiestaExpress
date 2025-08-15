module JwtAuthenticable
    extend ActiveSupport::Concern
  
    included do
      before_action :authenticate_api_user
    end
  
    def authenticate_api_user
      token = request.headers['Authorization']&.split(' ')&.last
      return head :unauthorized unless token
  
      begin
        payload = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
        @current_user = User.find(payload['user_id'])
        head :unauthorized if payload['exp'] < Time.now.to_i  # Expiry check
      rescue JWT::DecodeError
        head :unauthorized
      end
    end
  
    # Helper to issue tokens (call in sessions or auth controller)
    def issue_tokens(user)
      access_token = JWT.encode({ user_id: user.id, exp: 15.minutes.from_now.to_i }, Rails.application.credentials.secret_key_base)
      refresh_token = JWT.encode({ user_id: user.id, exp: 7.days.from_now.to_i }, Rails.application.credentials.secret_key_base)
      { access: access_token, refresh: refresh_token }
    end
  
    # Refresh endpoint (add to routes)
    def refresh
      refresh_token = params[:refresh_token]
      payload = JWT.decode(refresh_token, Rails.application.credentials.secret_key_base)[0]
      user = User.find(payload['user_id'])
      render json: issue_tokens(user)
    rescue
      head :unauthorized
    end
  end