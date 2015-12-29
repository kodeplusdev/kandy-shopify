class SessionStorage
  def self.store(session)
    shop = Shop.find_or_initialize_by(shopify_domain: session.url)
    shop.shopify_token = session.token
    shop.save!
    shop.id
  end

  def self.retrieve(id)
    return unless id
    shop = Shop.find(id)
    Session.new(shop)
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
