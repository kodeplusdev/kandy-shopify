class Webhooks::ShopController < WebhooksController
  def update
    render nothing: true, status: 200
    Thread.new do
      @shop.time_zone = params[:timezone].match(/\(.*\) (.*)/)[1]
      @shop.email = params[:email]
      @shop.phone = params[:phone]
      @shop.save
    end
  end
end