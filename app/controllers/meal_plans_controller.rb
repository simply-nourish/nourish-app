class MealPlansController < ApplicationController
  
  before_action :set_user, only: [:index, :create]
  before_action :set_meal_plan, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:index, :show, :create, :update, :destroy]

  # GET /users/:id/meal_plans
  def index
    render json: @user.meal_plans, status: :ok
  end

  def show

  end 

  def create

  end

  def update

  end 

  def destroy

  end 

  private

    # define acceptable params for post, patch
    def meal_plan_params
      params.require(:meal_plan).permit(:name, meal_plan_recipes_attributes:[:recipe_id, :day, :meal] )
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_meal_plan
      @meal_plan = MealPlan.find(params[:id])
    end

end
