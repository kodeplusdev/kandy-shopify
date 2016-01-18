class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :chat, :all

    if current_user.kandy_user.blank?
      if current_user.admin?
        flash[:error] = 'Please setup kandy user for your account.'
        redirect_to users_manage_edit_path(current_user) and return
      else
        flash[:error] = 'Please contact admin to setup kandy user for your account.'
        sign_out(current_user)
        redirect_to new_user_session_path and return
      end
    end
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
  end

  private

  def shop_params
    params.require(:shop).permit(:id, :kandy_api_key, :kandy_api_secret, :kandy_phone_number, :kandy_username, :kandy_password,
                                 template_attributes: [:id, :order_creation, :order_update, :order_payment, :customer_creation])
  end
end
