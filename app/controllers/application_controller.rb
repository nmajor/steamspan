class ApplicationController < ActionController::Base
  SPECIAL_KEY = 'mariopartysucks'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
