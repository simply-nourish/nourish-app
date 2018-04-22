# Ingredients controller
# /app/controllers/ingredients_controller.rb

class IngredientsController < ApplicationController

  before_action :set_ingredient_category, only: [:index, :create]
  before_action :set_ingredient, only: [:show, :update, :destroy]

  # GET /ingredient_categories/:ingredient_category_id/ingredients/
  def index
    render json: @ingredientcategory.ingredients, status: :ok
  end

  # GET /ingredients/:id
  def show 
    render json: @ingredient, status: :ok
  end

  # POST /ingredient_categories/:ingredient_category_id/ingredients/
  def create 
    @ingredientcategory.ingredients.create!(ingredient_params)
    render json: @ingredientcategory, status: :created
  end

  # PUT /ingredients/:id
  def update
    @ingredient.update(ingredient_params)
    head :no_content
  end

  # DELETE /ingredients/:id
  def destroy
    @ingredient.destroy
    head :no_content
  end

  private

    # define acceptable params
    def ingredient_params
      params.permit(:name, :ingredient_category_id)
    end

    # find a single ingredient_category
    def set_ingredient_category
      @ingredientcategory = IngredientCategory.find(params[:ingredient_category_id])
    end

    # find a single ingredient by id
    def set_ingredient
      @ingredient = Ingredient.find(params[:id])
    end

end
