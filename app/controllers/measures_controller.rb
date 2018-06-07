class MeasuresController < ApplicationController

# Measures controller
# /app/controllers/measures_controller.rb

  before_action :set_measure, only: [:show, :update, :destroy]
  
  # GET /measures
  def index
    @measures = Measure.all
    render json: @measures, status: :ok
  end

  # POST /measures
  def create
    @measure = Measure.create!(measure_params)
    render json: @measure, status: :created
  end

  # GET /measures/:id
  def show
    render json: @measure, status: :ok
  end

  # PUT /measures/:id
  def update 
    @measure.update(measure_params)
    head :no_content
  end

  # DELETE /measures/:id
  def destroy 
    @measure.destroy
    head :no_content
  end 

  private
  
    # set @measure for GET, UPDATE, DELETE
    def set_measure
      @measure = Measure.find(params[:id])
    end
  
    # whitelist fields
    def measure_params
      params.permit(:id, :name)
    end

end
