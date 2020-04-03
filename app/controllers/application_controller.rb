class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # adding 3/1/2020
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead
  protect_from_forgery with: :null_session, unless: -> { request.format.json? }

#  protect_from_forgery with: :exception

  include Authenticable 
  #Ben 6/17/2018 Moved the pagination helper into the APIController

  private
    def record_not_found_exception(exception)
      render json: { errors: "#{exception.message}" }, status: 422
    end
end
