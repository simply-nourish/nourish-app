class UsersController < ApplicationController

 # before_action :authenticate_user!

  # GET /users
  def index
  @users = User.all()
  render json: @users, status: :ok
  end

  # GET /users/:id
  def show 
    set_user()
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.create!(user_params)
    render json: @user, status: :created
  end

  # PUT /users/:id
  def update
    
  end

  # DELETE /users/:id
  def destroy
    
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
