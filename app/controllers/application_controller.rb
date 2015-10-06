class ApplicationController < ActionController::Base
  include ShopifyApp::Controller
  protect_from_forgery
end
