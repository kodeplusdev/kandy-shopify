class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_filter :shopify_session
  before_action :get_account_information

  protected

  def get_account_information
    # Pull the account information from the Header X-Shopify-Shop-Domain
    if request.post? # POST request only
      if request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN'].present?
        @shop = Shop.find_by_shopify_domain(request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN'])
      else
        # TODO: decide what to do for unrecognized webhooks.  Ignore for now
        puts 'Unknown webhook'
        render nothing: true
      end
    end
  end
end