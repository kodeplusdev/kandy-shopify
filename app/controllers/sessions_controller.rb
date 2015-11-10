class SessionsController < ApplicationController
  include ShopifyApp::SessionsController

  def new
    reset_session
    super
  end

  def callback
    reset_session
    super
  end
end
