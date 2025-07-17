module Api
  module V1
    class DashboardController < ApplicationController
      # GET /api/v1/dashboard
      def index
        render json: {
          message: "Welcome to your dashboard, #{current_user.email}!",
          user_id: current_user.id,
          timestamp: Time.current
        }
      end
    end
  end
end
