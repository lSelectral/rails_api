module Api
  module V2
    class BalanceController < ApplicationController
      # GET /api/v2/balance
      def show
        
        cache_key = "balance_cache:#{current_user.id}"
   
        cached = redis.get(cache_key)
        return render plain: cached, status: :ok if cached.present?

        balance = current_user.credits.to_i
        redis.setex(cache_key, 60, balance.to_s)

        render plain: balance.to_s, status: :ok
      rescue Redis::BaseError
        render plain: current_user.credits.to_i.to_s, status: :ok
      end
    end
  end
end
