module Api
  module V1
    class FeaturesController < ApplicationController
      # GET /api/v1/features
      def index
        features = {
          premium_features: Flipper.enabled?(:premium_features, current_user),
          api_rate_limiting: Flipper.enabled?(:api_rate_limiting),
          new_dashboard: Flipper.enabled?(:new_dashboard, current_user)
        }
        
        render json: { features: features }
      end
      
      # GET /api/v1/features/:name
      def show
        feature_name = params[:id].to_sym
        is_enabled = Flipper.enabled?(feature_name, current_user)
        
        render json: { 
          feature: feature_name,
          enabled: is_enabled
        }
      end
    end
  end
end
