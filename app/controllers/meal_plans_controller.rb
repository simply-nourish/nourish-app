# MealPlans controller
# /app/controllers/meal_plans_controller.rb

class MealPlansController < ApplicationController

  before_action :authenticate_user!  
  before_action :set_user, only: [:index, :create]
  before_action :set_meal_plan, only: [:show, :update, :destroy]

  # GET /users/:id/meal_plans
  def index
    if @user == current_user
      render json: @user.meal_plans, status: :ok
    else 
      render status: :unauthorized
    end 
  end

  # GET /meal_plans/:id
  def show
    if @meal_plan.user == current_user
      render json: @meal_plan, status: :ok
    else
      render status: :unauthorized
    end 
  end 

  # POST /users/:id/meal_plans
  def create
    if @user == current_user
      @meal_plan = @user.meal_plans.create!(meal_plan_params)
      if @meal_plan.persisted?
        render json: @meal_plan, status: :created
      else
        render status: :not_found
      end
    else
      render status: :unauthorized
    end 
  end

  # PUT /meal_plans/:id
  def update
    if @meal_plan.user == current_user
      @meal_plan.update(meal_plan_params)
      head :no_content    
    else
      render status: :unauthorized
    end 
  end 

  # DELETE /meal_plans/:id
  def destroy
    if @meal_plan.user == current_user
      @meal_plan.destroy
      head :no_content
    else
      render status: :unauthorized
    end
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
