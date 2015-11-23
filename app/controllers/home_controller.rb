class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
  end

  private

  def authenticate_user!
    if session[:initialized].blank?
      @shop = Shop.find_by_shopify_domain(@shop_session.url)
      unless @shop.blank?
        if @shop.initialized
          session[:initialized] = 1
          super
        else
          redirect_to installed_path(request.query_parameters)
        end
      else
        super
      end
    else
      super
    end
  end

  def shop_params
    params.require(:shop).permit(:id, :kandy_api_key, :kandy_api_secret, :kandy_phone_number, :kandy_username, :kandy_password,
                                 template_attributes: [:id, :order_creation, :order_update, :order_payment, :customer_creation])
  end
end
