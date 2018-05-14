# Users controller
# /app/controllers/users_controller.rb

class UsersController < ApplicationController

  # NOTE: create, delete, put actions all handled by devise_token_auth

  before_action :authenticate_user!

  # GET /users
  def index
    @users = User.all()
    render json: @users, each_serializer: AbbrevUserSerializer, status: :ok
  end

  # GET /users/:id
  def show 
    set_user()
    if( (current_user.id).to_s == ( params[:id]).to_s )
      # allow expanded user data for current user
      render json: @user, serializer: CompleteUserSerializer, status: :ok
    else
      # restrict data shown about other users
      render json: @user, serializer: AbbrevUserSerializer, status: :ok
    end
  end

  private

    # define acceptable params
    def user_params
      params.permit(:id, :first_name, :last_name, :email, :nickname, :default_servings)
    end

    def set_user
      @user = User.find(params[:id])
    end

end
