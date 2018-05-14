# exception handler for json responses, when item not in database
# adapted from: https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one

module ExceptionHandler

  # extending Concern gives us 'included' syntax
  extend ActiveSupport::Concern

  included do 
    # handle 'record not found' errors
    # return error message+ '404'
    rescue_from ActiveRecord::RecordNotFound do |e|
      # return json response containing error message, status of :not_found
      render json: {message: e.message}, status: :not_found
    end

    # handle 'invalid record' errors
    # return error message + '422'
    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: {message: e.message}, status: :unprocessable_entity
    end

    # handle 'parameter missing' errors
    # return error message + '400'
    rescue_from ActionController::ParameterMissing do |e|
      render :nothing => true, status: :bad_request
    end

  end

end


