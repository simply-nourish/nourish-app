# Shopping List controller
# /app/controllers/recipes_controller.rb

class ShoppingListsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_shopping_list, only: [:show, :update, :destroy]
  before_action :set_user, only: [:index, :create]

  #
  # GET /users/:id/shopping_lists
  #

  def index
    if @user == current_user
      render json: @user.shopping_lists, status: :ok
    else 
      render status: :unauthorized
    end 
  end 

  #
  # GET /users/:id/shopping_lists/:id
  #

  def show
    if @shopping_list.user == current_user
      render json: @shopping_list, status: :ok
    else
      render status: :unauthorized
    end 
  end

  #
  # POST /users/:id/shopping_lists
  # params: meal_plan_id, name (i.e., shopping list name)
  #

  def create

    if @user != current_user
      render status: :unauthorized and return
    end 

    # will store aggregated data. format (key => value): [ingredient_id, measure_id] => amount
    ing_amt_map = {}

    # find meal plan, create an initial shopping list with that meal plan
    @meal_plan = MealPlan.find(shopping_list_create_params[:meal_plan_id])
    @shopping_list = @user.shopping_lists.create!(shopping_list_create_params)

    # if there was a problem saving, catch it
    if @shopping_list.persisted? == false
      render status: :not_found and return
    end 

    # for reach recipe in meal plan, collect ingredient data, aggregate / consolidate per unit of measure
    @meal_plan.recipes.each do |rec|

      # fetch ingredient_recipes
      @recipe = Recipe.find(rec.id)   
      ingredient_recipes = @recipe.ingredient_recipes
      ingredient_recipes.each do |ing_rec|
        # the key for each entry in our map will be the combination of (ingredient_id, measure_id) 
        ing_measure = [ing_rec.ingredient_id, ing_rec.measure_id]

        # check if the key exists - if so, add associated amount
        # if the key does not exist, create new entry in map
        if( ing_amt_map.key?(ing_measure) )
          ing_amt_map[ ing_measure ] += ing_rec.amount
        else
          ing_amt_map[ ing_measure ] = ing_rec.amount
        end

      end 

    end 

    # now, create ingredient_shopping_lists with aggregated data - 
    # assume all new ingredients are unpurchased
    ing_amt_map.each do |key, agg_amount|
      @shopping_list.ingredient_shopping_lists.create!(ingredient_id: key.first, 
                                                       measure_id: key.second, 
                                                       amount: agg_amount, 
                                                       purchased: false)
    end 

    # render resulting shopping list and its attendant ingredients
    render json: @shopping_list, status: :created

  end 

  #
  # PUT /shopping_lists/:id
  # 

  def update

    if @shopping_list.user == current_user
    
      @shopping_list.update({:name => shopping_list_update_params[:name]}.reject{|k,v| v.blank?} )
      
      # update each nested ingredient_shopping_list entry manually
      if( shopping_list_update_params[:ingredient_shopping_lists_attributes] )
        shopping_list_update_params[:ingredient_shopping_lists_attributes].each do |ing_sl|
          @ingredient_shopping_list = @shopping_list.ingredient_shopping_lists.find_by( ingredient_id: ing_sl[:ingredient_id], measure_id: ing_sl[:measure_id] ) 
       
          if @ingredient_shopping_list && ing_sl[:_destroy] == '1'
            @ingredient_shopping_list.destroy()
          elsif @ingredient_shopping_list
            @ingredient_shopping_list.update!({:amount => ing_sl[:amount], :purchased => ing_sl[:purchased]}.reject{|k,v| v.blank?})
          else
            @shopping_list.ingredient_shopping_lists.create!(ing_sl)
          end

        end
      end

      head :no_content    
  
    else
      render status: :unauthorized
    end  

  end

  #
  # DELETE /shopping_lists/:id
  # 

  def destroy
    if @shopping_list.user == current_user
      @shopping_list.destroy()
      head :no_content
    else
      render status: :unauthorized
    end 
  end 

  private    # define acceptable params 

    def shopping_list_create_params
      params.require(:shopping_list).permit(:name, :meal_plan_id)
    end

    def shopping_list_update_params
      params.require(:shopping_list).permit(:name, ingredient_shopping_lists_attributes: [:ingredient_id, :measure_id, :amount, :purchased, :_destroy])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_shopping_list
      @shopping_list = ShoppingList.find(params[:id])
    end

end
