class WebhooksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_filter :shopify_session
  before_action :verify_request

  private

  def get_account_information
    # Pull the account information from the Header X-Shopify-Shop-Domain
    if request.post? # POST request only
      if shop_domain.blank?
        # TODO: decide what to do for unrecognized webhooks.  Ignore for now
        puts 'Unknown webhook'
        render nothing: true
      else
        @shop = Shop.find_by_shopify_domain(shop_domain)
      end
    end
  end

  def verify_request
    request.body.rewind
    data = request.body.read

    if validate_hmac(ShopifyApp.configuration.secret, data)
      get_account_information
    else
      head :unauthorized
    end
  end

  def validate_hmac(secret, data)
    digest = OpenSSL::Digest.new('sha256')
    shopify_hmac == Base64.encode64(OpenSSL::HMAC.digest(digest, secret, data)).strip
  end

  def shop_domain
    request.headers['HTTP_X_SHOPIFY_SHOP_DOMAIN']
  end

  def shopify_hmac
    request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
  end
end