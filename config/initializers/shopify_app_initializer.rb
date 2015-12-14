ShopifyApp.configure do |config|
  config.api_key = ENV['SHOPIFY_CLIENT_API_KEY']
  config.secret = ENV['SHOPIFY_CLIENT_API_SECRET']
  config.redirect_uri = ENV['KANDY_SHOPIFY_HOST'] + '/auth/shopify/callback'
  config.scope = 'read_customers, read_orders, read_products, read_fulfillments, read_shipping, write_script_tags, read_script_tags'
  config.embedded_app = true
end
