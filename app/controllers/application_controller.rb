class ApplicationController < ActionController::Base
  # adding 3/1/2020
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead
  protect_from_forgery with: :null_session, unless: -> { request.format.json? }

#  protect_from_forgery with: :exception

  include Authenticable 
  #Ben 6/17/2018 Moved the pagination helper into the APIController
end
