module Api
  module V1
    class HealthController < ApplicationController
      skip_before_action :authenticate_user!
      
      # GET /api/v1/health
      def index
        health_status = {
          status: 'ok',
          version: Rails.application.config.version || '1.0.0',
          timestamp: Time.current,
          environment: Rails.env,
          database: database_connected?,
          redis: redis_connected?
        }
        
        render json: health_status
      end
      
      private
      
      def database_connected?
        ActiveRecord::Base.connection.active? rescue false
      end
      
      def redis_connected?
        Redis.current.ping == 'PONG' rescue false
      end
    end
  end
end
