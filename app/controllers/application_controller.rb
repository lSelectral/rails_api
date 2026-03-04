class ApplicationController < ActionController::API
	before_action :authenticate_request!

	private

	def authenticate_request!
		token = authorization_token

		if token.blank?
			render json: { error: 'Yetkisiz erişim' }, status: :unauthorized
			return
		end

		payload = decode_token(token)
		@current_user = User.find_by(id: payload['user_id'])

		return if @current_user

		render json: { error: 'Yetkisiz erişim' }, status: :unauthorized
	rescue JWT::DecodeError, JWT::ExpiredSignature
		render json: { error: 'Geçersiz veya süresi dolmuş token' }, status: :unauthorized
	end

	def current_user
		@current_user
	end

	def redis
		return $redis if defined?($redis) && $redis.present?

		@redis ||= Redis.new(url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0'))
	end

	def json_body
		return {} if request.body.nil?

		raw = request.body.read
		request.body.rewind
		return {} if raw.blank?

		parsed = JSON.parse(raw)
		parsed.is_a?(Hash) ? parsed.deep_symbolize_keys : {}
	rescue JSON::ParserError
		{}
	end

	def authorization_token
		header = request.headers['Authorization'].to_s
		match = header.match(/\ABearer Token\s+(.+)\z/)
		match&.captures&.first
	end

	def decode_token(token)
		JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256').first
	end
end
