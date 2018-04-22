# IngredientCategories controller
# /app/controllers/ingredient_categories_controller.rb

class IngredientCategoriesController < ApplicationController

  before_action :set_ingredient_category, only: [:show, :update, :destroy]

  # GET /ingredient_categories
  def index
    @ingredientcategories = IngredientCategory.all
    render json: @ingredientcategories, status: :ok
  end

  # POST /ingredient_categories
  def create
    @ingredientcategory = IngredientCategory.create!(ingredient_category_params)
    render json: @ingredientcategory, status: :created
  end

  # GET /ingredient_categories/:id
  def show
    render json: @ingredientcategory, status: :ok
  end

  # UPDATE /ingredient_categories/:id
  def update 
    @ingredientcategory.update(ingredient_category_params)
    head :no_content
  end

  # DELETE /ingredient_categories/:id
  def destroy 
    @ingredientcategory.destroy
    head :no_content
  end 
  
  private
  
    # set @ingredientcategory for GET, UPDATE, DEPETE
    def set_ingredient_category
      @ingredientcategory = IngredientCategory.find(params[:id])
    end

    # whitelist fields
    def ingredient_category_params
      params.permit(:name)
    end

end
