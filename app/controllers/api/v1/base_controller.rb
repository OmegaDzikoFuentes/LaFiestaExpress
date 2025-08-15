class Api::V1::BaseController < ApplicationController
   include JwtAuthenticable
    skip_forgery_protection
    before_action :authenticate_api_user
    private
    def authenticate_api_user
      token = request.headers["Authorization"]&.split(" ")&.last
      @current_user = User.find_by(api_token: token)
      head :unauthorized unless @current_user
    end
end
