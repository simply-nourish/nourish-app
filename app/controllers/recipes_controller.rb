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
      @recipe.update!( {:title => recipe_params[:title], 
                        :summary => recipe_params[:summary], 
                        :instructions => recipe_params[:instructions]}.reject{|k,v| v.blank?} )
      
      # update each nested ingredient_shopping_list entry manually
      if( recipe_params[:ingredient_recipes_attributes])
  
        recipe_params[:ingredient_recipes_attributes].each do |ing_rec|    
          @ingredient_recipe = @recipe.ingredient_recipes.find_by( ingredient_id: ing_rec[:ingredient_id] ) 
       
          if @ingredient_recipe   
            if ing_rec[:_destroy] == '1'
              @ingredient_recipe.destroy()
            else
              @ingredient_recipe.update!( {:amount => ing_rec[:amount], :measure_id => ing_rec[:measure_id]}.reject{|k,v| v.blank?} )        
            end 
          end
        end
  
      end

      if( recipe_params[:dietary_restriction_recipes_attributes] )
   
        recipe_params[:dietary_restriction_recipes_attributes].each do |diet_rec|       
          @dietary_restriction_recipe = recipe.dietary_restriction_recipes.find_by( dietary_restriction_id: diet_rec[:dietary_restriction_id] )
       
          if @dietary_restriction_recipe 
            if diet_rec[:_destroy] == '1'
              @dietary_restriction_recipe.destroy()
            else
              @dietary_restriction_recipe.update!( {:dietary_restriction_id => diet_rec[:dietary_restriction_id]}.reject{|k,v| v.blank?} )        
            end
          end    
        end
   
      end

      head :no_content    
    
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
      params.require(:recipe).permit(:title, :summary, :instructions, 
                                     dietary_restriction_recipes_attributes: [:id, :dietary_restriction_id], 
                                     ingredient_recipes_attributes: [:id, :ingredient_id, :measure_id, :amount, :_destroy] )
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

end
