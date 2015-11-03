class PreferencesController < ApplicationController
  layout 'embedded_app'
  around_filter :shopify_session
  before_action :shop, except: [:index, :update]

  def index
  end

  def update
    @shop = Shop.find(params[:shop][:id])
    if @shop.update_attributes(shop_params)
      unless @shop.kandy_password.blank?
        kandy = Kandy.new(api_key: @shop.kandy_api_key, api_secret: @shop.kandy_api_secret)

        @shop.kandy_username = @shop.kandy_username.split('@').first unless @shop.kandy_username.blank?
        res = kandy.get_user_access_token(@shop.kandy_username, @shop.kandy_password)

        if res['status'] == 1
          flash[:error] = res['message']
        else
          @shop.kandy_access_token = res['result']['user_access_token']
          @shop.save
          flash[:notice] = 'Updated successfull'
        end
      else
        flash[:notice] = 'Updated successfull'
      end
    else
      flash[:error] = @shop.errors.full_messages.first
    end
    redirect_to params[:back_url]
  end

  def api_keys
  end

  def kandy_account
  end

  def sms_alert_templates
  end

  def chat_box_widget
  end

  private

  def shop
    @shop = Shop.find_by_shopify_domain(params[:shop] || @shop_session.url)
  end

  def shop_params
    params.require(:shop).permit(:id, :kandy_api_key, :kandy_api_secret, :kandy_username, :kandy_password,
                                 template_attributes: [:id, :order_creation, :order_update, :order_payment, :customer_creation],
                                 profile_attributes: [:id, :first_name, :last_name, :phone_number, :email])
  end
end