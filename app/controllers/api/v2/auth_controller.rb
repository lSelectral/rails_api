module Api
  module V2
    class AuthController < ApplicationController
      skip_before_action :authenticate_request!

      def login
        user = User.find_by(username: json_body[:username])

        if user&.authenticate(json_body[:password])
          token = generate_token(user)
          render json: { token: token, username: user.username }, status: :ok
        else
          render json: { error: 'Geçersiz kullanıcı adı veya şifre' }, status: :unauthorized
        end
      end

      private

      def generate_token(user)
        payload = {
          user_id: user.id,
          exp: 24.hours.from_now.to_i
        }
        JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
      end
    end
  end
end
