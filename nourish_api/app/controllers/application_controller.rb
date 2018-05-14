# ApplicationController
# /app/controllers/application_controller.rb

class ApplicationController < ActionController::API
   
  include DeviseTokenAuth::Concerns::SetUserByToken

  include ExceptionHandler

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    # permit additional parameters for user sign up and account updates 
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :first_name, :last_name, :image, :email, :default_servings])
      devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :first_name, :last_name, :image, :email, :default_servings])
    end

end
