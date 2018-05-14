# DietaryRestrictions controller
# /app/controllers/dietary_restrictions_controller.rb

class DietaryRestrictionsController < ApplicationController

    before_action :set_dietary_restriction, only: [:show, :update, :destroy]
  
    # GET /dietary_restrictions
    def index
      @dietary_restrictions = DietaryRestriction.all
      render json: @dietary_restrictions, status: :ok
    end
  
    # POST /dietary_restrictions
    def create
      @dietary_restriction = DietaryRestriction.create!(dietary_restriction_params)
      render json: @dietary_restriction, status: :created
    end
  
    # GET /dietary_restrictions/:id
    def show
      render json: @dietary_restriction, status: :ok
    end
  
    # UPDATE /dietary_restrictions/:id
    def update 
      @dietary_restriction.update(dietary_restriction_params)
      head :no_content
    end
  
    # DELETE /dietary_restrictions/:id
    def destroy 
      @dietary_restriction.destroy
      head :no_content
    end 
    
    private
    
      # set @dietary_restriction for GET, UPDATE, DELETE
      def set_dietary_restriction
        @dietary_restriction = DietaryRestriction.find(params[:id])
      end
  
      # whitelist fields
      def dietary_restriction_params
        params.permit(:name)
      end
  
end
