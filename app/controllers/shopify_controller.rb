class ShopifyController < WebhooksController
  def uninstalled
    render nothing: true, status: 200
    Thread.new do
      shop = Shop.find_by_shopify_domain(params[:domain])
      shop.destroy!
      reset_session
    end
  end
end