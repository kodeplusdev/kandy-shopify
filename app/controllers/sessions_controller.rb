class SessionsController < ApplicationController
  include ShopifyApp::SessionsController

  def new
    reset_session
    super
  end
end
