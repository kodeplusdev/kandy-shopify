class HomeController < ApplicationController
  layout 'embedded_app'
  around_filter :shopify_session
  before_action :is_initialized, except: :install

  def index
  end

  def preferences
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
  end

  def update_preferences
    @shop = Shop.find(params[:shop][:id])
    if @shop.update_attributes(shop_params)
      unless @shop.kandy_password.blank?
        kandy = Kandy.new(api_key: @shop.kandy_api_key, api_secret: @shop.kandy_api_secret)

        @shop.kandy_username = @shop.kandy_username.split('@').first unless @shop.kandy_username.blank?
        res = kandy.get_user_access_token(@shop.kandy_username, @shop.kandy_password)

        if res['status'] == 1
          flash[:error] = res['message']
        else
          @shop.kandy_token = res['result']['user_access_token']
          @shop.save
          flash[:notice] = 'Updated successfull'
        end
      else
        flash[:notice] = 'Updated successfull'
      end
    else
      flash[:error] = @shop.errors.full_messages.first
    end
    render :preferences
  end

  def install
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
    @shop.template = Template.new
    @shop.save!

    shopify_service = ShopifyIntegration.new(domain: root_url)
    shopify_service.setup_webhooks
    redirect_to session['return_url'] || root_url
  end

  def error
    raise "error"
  end

  private

  def is_initialized
    if session[:initialized].blank?
      @shop = Shop.find_by_shopify_domain(@shop_session.url)
      if @shop.template
        session[:initialized] = 1
      else
        redirect_to action: :install
      end
    end
  end

  def shop_params
    params.require(:shop).permit(:id, :kandy_api_key, :kandy_api_secret, :kandy_phone_number, :kandy_username, :kandy_password,
                                 template_attributes: [:id, :order_creation, :order_update, :order_payment, :customer_creation])
  end
end
