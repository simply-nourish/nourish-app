class RecipesController < ApplicationController

  before_action :set_recipe, only: [:show, :update, :destroy]
 # before_action :authenticate_user!, only: [:create, :update, :destroy]

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
    set_recipe()
    render json: @recipe, status: :ok
  end

  # POST /users/:id/recipes
  def create
    set_user()
    @recipe = @user.recipes.create(recipe_post_params)

    if @recipe.persisted?
      render json: @recipe, status: :created
    else
      render status: :not_found
   #   raise ActiveRecord::RecordInvalid
    end
  end

  # PUT /recipes/:id
  def update
    set_recipe()
    @recipe.update(recipe_post_params)
  end

  # DELETE /recipes/:id
  def destroy
    set_recipe()
    @recipe.destroy
    head :no_content
  end

  private

    # define acceptable params for post, patch
    def recipe_post_params
      # need to integrate dietary restrictions
       params.require(:recipe).permit(:title, :summary, :instructions, ingredient_recipes_attributes:[:ingredient_id, :measure_id, :amount] )
    end

    def recipe_patch_params
      params.require(:recipe).permit(:title, :summary, :instructions, ingredient_recipes_attributes:[:ingredient_id, :measure_id, :amount] )
    end      

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

end


