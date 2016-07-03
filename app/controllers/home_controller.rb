class HomeController < ApplicationController
  before_action :authenticate_user!

  # GET /
  def index
    authorize! :chat, :all

    @shop = Shop.find_by_shopify_domain(@shop_session.url)

    # check kandy users empty?
    if current_user.kandy_user.blank?
      if current_user.admin?
        flash[:error] = 'Please setup kandy user for your account.'
        redirect_to users_manage_edit_path(current_user) and return
      else
        flash[:error] = 'Please contact admin to setup kandy user for your account.'
        sign_out(current_user)
        redirect_to new_user_session_path and return
      end
    else if current_user.kandy_user.password.blank?
           kandy = Kandy.new(domain_api_key: @shop.kandy_api_key, domain_api_secret: @shop.kandy_api_secret)
           current_user.kandy_user.access_token = kandy.user_access_token(username: current_user.kandy_user.username)
         end
    end
  end
end
