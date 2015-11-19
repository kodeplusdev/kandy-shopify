class ShopifyController < ApplicationController
  layout 'embedded_app'
  skip_before_filter :verify_authenticity_token, only: :script_tags
  skip_filter :shopify_session, only: [:script_tags]

  def installed
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
    if @shop.initialized
      redirect_to root_url
    end
  end

  def setup
    email = params[:email]
    if email.blank? || !(email =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      flash[:error] = 'A valid email is required.'
      render :installed
    else
      @shop = Shop.find_by_shopify_domain(params[:shop])
      if @shop.initialized
        redirect_to root_url
      end

      @shop.template = Template.new
      @shop.widget = Widget.new(name: 'Live Chat', color: '#000000', enabled: false)
      @shop.users.invite!(email: email, role: User::ADMIN)
      @shop.initialized = true
      session[:initialized] = 1
      @shop.save!

      setup_webhooks
      setup_script_tags

      flash.now[:notice] = 'An invitation email has been sent.'
      redirect_to session['return_url'] || root_url
    end
  end

  def script_tags
    @shop = Shop.find_by_shopify_domain(params[:shop])
    render layout: false
  end

  private

  def setup_webhooks
    begin
      webhooks = ShopifyAPI::Webhook.find :all
      webhooks.each do |webhook|
        webhook.destroy if webhook.address.include?(root_url)
      end
      [
          {url: webhooks_app_uninstalled_url, topic: 'app/uninstalled'},
          {url: webhooks_order_creation_url, topic: 'orders/create'},
          {url: webhooks_order_update_url, topic: 'orders/updated'},
          {url: webhooks_order_payment_url, topic: 'orders/paid'},
          {url: webhooks_customer_creation_url, topic: 'customers/create'}
      ].each do |webhook|
        ShopifyAPI::Webhook.create(address: webhook[:url], topic: webhook[:topic], format: 'json')
      end

    rescue => ex
      puts ex.message
    end
  end

  def setup_script_tags
    begin
      tags = ShopifyAPI::ScriptTag.find :all
      tags.each do |tag|
        tag.destroy if tag.src.include?(root_url)
      end
      [script_tags_url].each do |tag|
        ShopifyAPI::ScriptTag.create(src: tag, event: 'onload')
      end
    rescue => ex
      puts ex.message
    end
  end

end