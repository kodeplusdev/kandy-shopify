class SessionsController < ApplicationController
  include ShopifyApp::SessionsController
  layout 'application'
  skip_filter :shopify_session

  # GET /login
  def new
    reset_session
    super
  end

  # GET /auth/shopify/callback
  def callback
    reset_session
    super
  end
end
