class ApplicationController < ActionController::Base
  include ShopifyApp::Controller
  layout 'embedded_app'
  around_filter :shopify_session
  protect_from_forgery

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path(shop: @shop_session.url)
  end

  def error
    raise 'Error'
  end
end
