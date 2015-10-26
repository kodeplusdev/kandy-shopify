class ShopifyController < WebhooksController

  def script_tags
    @shop = params[:shop]
    render layout: false
  end

  def uninstalled
    render nothing: true, status: 200
    Thread.new do
      shop = Shop.find_by_shopify_domain(params[:domain])
      shop.destroy!
      reset_session
    end
  end
end