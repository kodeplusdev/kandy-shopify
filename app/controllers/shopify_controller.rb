class ShopifyController < WebhooksController
  def uninstalled
    shop = Shop.find_by_shopify_domain(params[:domain])
    shop.destroy!
    reset_session
    head :ok
  end
end