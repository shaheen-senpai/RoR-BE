# frozen_string_literal: true

module Api
  module V1
    class HealthController < ApplicationController
      skip_before_action :authenticate_user!

      # GET /api/v1/health
      def index
        health_status = {
          status: 'ok',
          timestamp: Time.current,
          environment: Rails.env,
          database: database_connected?,
          redis: redis_connected?
        }
        render json: health_status
      end

      private

      def database_connected?
        ActiveRecord::Base.connection.active?
      rescue StandardError
        false
      end

      def redis_connected?
        Redis.new.ping == 'PONG'
      rescue StandardError
        false
      end
    end
  end
end
