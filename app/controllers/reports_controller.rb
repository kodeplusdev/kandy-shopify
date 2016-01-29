class ReportsController < ApplicationController
  before_action :authenticate_user!

  # GET /reports
  def index
    authorize! :read, :report

    @shop = Shop.find_by_shopify_domain(@shop_session.url)
    @conversations = @shop.conversations
    @users = @shop.users.all
  end
end