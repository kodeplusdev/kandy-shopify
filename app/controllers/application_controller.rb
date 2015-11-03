class ApplicationController < ActionController::Base
  include ShopifyApp::Controller
  protect_from_forgery

  def error
    raise 'Error'
  end
end
