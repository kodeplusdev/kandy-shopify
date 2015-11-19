class ApplicationController < ActionController::Base
  include ShopifyApp::Controller
  layout 'embedded_app'
  around_filter :shopify_session
  protect_from_forgery

  def error
    raise 'Error'
  end
end
