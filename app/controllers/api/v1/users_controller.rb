module Api
  module V1
    class UsersController < ApplicationController
      include Paginable
      
      before_action :set_user, only: [:show, :update, :destroy]
      skip_before_action :authenticate_user!, only: [:create]
      
      # GET /api/v1/users
      def index
        users = User.all
        result = paginate(users)
        
        render json: {
          users: ActiveModel::Serializer::CollectionSerializer.new(
            result[:data],
            serializer: UserSerializer
          ),
          meta: result[:meta]
        }
      end
      
      # GET /api/v1/users/:id
      def show
        render json: @user, serializer: UserSerializer
      end
      
      # POST /api/v1/users
      def create
        @user = User.new(user_params)
        
        if @user.save
          token = @user.generate_jwt
          render json: { token: token, user: UserSerializer.new(@user) }, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      # PATCH/PUT /api/v1/users/:id
      def update
        if @user.update(user_params)
          render json: @user, serializer: UserSerializer
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      # DELETE /api/v1/users/:id
      def destroy
        @user.destroy
        head :no_content
      end
      
      private
      
      def set_user
        @user = User.find(params[:id])
      end
      
      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end
