# Shopping List controller
# /app/controllers/recipes_controller.rb

class ShoppingListsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_shopping_list, only: [:show, :update, :destroy]
  before_action :set_user, only: [:index, :create]

  def index
    if @user == current_user
      render json: @user.shopping_lists, status: :ok
    else 
      render status: :unauthorized
    end 
  end 

  def show

  end

  def create

    # take meal plan

    # for each recipe in meal_plan_recipes:
    #    aggregate recipe ingredient data

    # store aggregated data

  end 

  def update

  end

  def destroy

  end 

  private    # define acceptable params 
  def shopping_list_params
    params.require(:shopping_list).permit(:name, :meal_plan_id)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_shopping_list
    @shopping_list = ShoppingList.find(params[:id])
  end

end
