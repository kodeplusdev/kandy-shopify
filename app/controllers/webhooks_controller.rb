class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :get_account_information

  protected

  def get_account_information
    # Pull the account information from the Header X-Shopify-Shop-Domain
    if request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN'].present?
      @shop = Shop.find_by_shopify_domain(request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN'])
    else
      redirect_to action: :unknown_webhook
    end
  end

  def unknown_webhook
    # TODO: decide what to do for unrecognized webhooks.  Ignore for now
    render text: 'Unknown account', status: 200
  end
end