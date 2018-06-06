# Recipes controller
# /app/controllers/recipes_controller.rb

class RecipesController < ApplicationController

  before_action :set_recipe, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  # GET /recipes (public only) --> do search with query params
  # GET /users/:id/recipes
  def index
    if params[:user_id]
      set_user()
      render json: @user.recipes, status: :ok
    else
      @recipes = Recipe.all
      render json: @recipes, status: :ok
    end 
  end

  # GET /recipes/:id
  def show
    render json: @recipe, status: :ok
  end

  # POST /users/:id/recipes
  def create
    set_user()
    if @user == current_user
      @recipe = @user.recipes.create!(recipe_params)
      if @recipe.persisted?
        render json: @recipe, status: :created
      else
        render status: :not_found
      end
    else 
      render status: :unauthorized
    end 
  end

  # PUT /recipes/:id
  def update

    if @recipe.user == current_user
      if(@recipe.update(recipe_params))
        @recipe.save
        head :no_content
      else
        render status: :unprocessable_entity
      end
    else
      render status: :unauthorized
    end

  end

  # DELETE /recipes/:id
  def destroy
    if @recipe.user == current_user
      @recipe.destroy
      head :no_content
    else
      render status: :unauthorized
    end
  end

  # GET /recipes/search
  def search
    if params[:q] && params[:q].length > 0
    # search for partial matches with LIKE %param%
    # prioritize title matches, then summary matches, then others
      @recipes = Recipe.where('title LIKE ?', "%#{params[:q]}%").or(
                 Recipe.where('summary LIKE ?', "%#{params[:q]}%")).or( 
                 Recipe.where('instructions LIKE ?', "%#{params[:q]}%") )
  
      render json: @recipes, status: :ok
    else
      render json: [], status: :ok
    end 
  end 

  private

    # define acceptable params for post, patch
    def recipe_params
      params.require(:recipe).permit(:title, :summary, :instructions, :servings,
                                     dietary_restriction_recipes_attributes: [:id, :dietary_restriction_id, :_destroy], 
                                     ingredient_recipes_attributes: [:id, :ingredient_id, :measure_id, :amount, :_destroy] )
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

end
