class Session < ShopifyAPI::Session
  attr_accessor :id, :initialized, :email, :phone, :time_zone

  def initialize(shop)
    super(shop.shopify_domain, shop.shopify_token)
    self.id = shop.id
    self.initialized = shop.initialized
    self.email = shop.email
    self.phone = shop.phone
    self.time_zone = shop.time_zone
  end
end