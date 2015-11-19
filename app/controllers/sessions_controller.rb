class SessionsController < ApplicationController
  include ShopifyApp::SessionsController
  layout 'application'
  skip_filter :shopify_session

  def new
    reset_session
    super
  end

  def callback
    reset_session
    super
  end
end
