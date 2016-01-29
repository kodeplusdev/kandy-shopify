class Webhooks::UninstalledController < WebhooksController

  # POST /webhooks/app/uninstalled
  def index
    render nothing: true, status: 200
    Thread.new do
      shop = Shop.find_by_shopify_domain(params[:domain])
      shop.initialized = false
      shop.save!
      # shop.destroy!
      reset_session
    end
  end
end