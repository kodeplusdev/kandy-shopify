class ShopifyIntegration

  attr_accessor :domain

  def initialize params = {}
    self.domain = params[:domain] || 'https://'
  end

  def setup_webhooks
    begin
      webhooks = ShopifyAPI::Webhook.find :all
      webhooks.each do |webhook|
        webhook.destroy if webhook.address.include?(domain)
      end
      [
          {url: 'app/uninstalled', topic: 'app/uninstalled'},
          {url: 'sms/order-creation', topic: 'orders/create'},
          {url: 'sms/order-update', topic: 'orders/updated'},
          {url: 'sms/order-payment', topic: 'orders/paid'},
          {url: 'sms/customer-creation', topic: 'customers/create'}
      ].each do |webhook|
        ShopifyAPI::Webhook.create(address: domain + webhook[:url], topic: webhook[:topic], format: 'json')
      end

    rescue => ex
      puts ex.message
    end
  end

  def setup_script_tags
    begin
      tags = ShopifyAPI::ScriptTag.find :all
      tags.each do |tag|
        tag.destroy if tag.src.include?(domain)
      end
      ['app/script-tags'].each do |tag|
        ShopifyAPI::ScriptTag.create(src: domain + tag, event: 'onload')
      end
    rescue => ex
      puts ex.message
    end
  end
end