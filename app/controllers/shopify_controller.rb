class ShopifyController < ApplicationController
  layout 'embedded_app'
  skip_before_filter :verify_authenticity_token, only: :script_tags
  skip_filter :shopify_session, only: [:script_tags]

  # GET /app/script-tags
  def script_tags
    @shop = Shop.find_by_shopify_domain(params[:shop])
    render layout: false
  end
end