class InstalledController < ApplicationController
  layout 'embedded_app'
  skip_before_filter :verify_authenticity_token
  before_action :load_shop

  def index
    if @shop.initialized
      redirect_to root_url
    else
      if @shop.users.size > 0
        update_shop_details

        @shop.phone = @shop_details.phone
        @shop.save

        setup_webhooks
        setup_script_tags

        redirect_to session['return_url'] || root_url and return
      end
    end

    session[:step] ||= 0

    if params[:step] == '2' && session[:step] == 1
      @kandy_users = @shop.kandy_users.all
      render 'admin_account'
    else
      if params[:step] == '3' && session[:step] == 2
        redirect_to root_url
      end
    end
  end

  def set_kandy_account
    if @shop.update_attributes(shop_params)
      kandy = Kandy.new(domain_api_key: @shop.kandy_api_key, domain_api_secret: @shop.kandy_api_secret)
      users = kandy.domain_users
      if users.blank? || users.size < 2
        flash[:error] = 'Your kandy account should have least 2 users.'
      else
        users.each do |u|
          @shop.kandy_users.create(username: u.user_id, email: u.user_email, password: u.user_password,
                                   first_name: u.user_first_name, last_name: u.user_last_name, phone_number: u.user_phone_number,
                                   api_key: u.user_api_key, api_secret: u.user_api_secret, country_code: u.user_country_code, domain_name: u.domain_name)
        end
        session[:step] = 1
        redirect_to action: :index, step: 2 and return
      end
      render :index
    end
  end

  def set_admin_account
    email = params[:email]
    password = params[:password]

    if email.blank? || !(email =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      flash[:error] = 'A valid email is required'
    else
      if password.blank? || password.length < 8 || password != params[:password_confirmation]
        flash[:error] = 'A valid password is required (8-min)'
      else
        if params[:kandy_user_id].blank? || params[:kandy_user_guest_id].blank? || params[:kandy_user_id] == params[:kandy_user_guest_id]
          flash[:error] = 'Two kandy users have to be different and not be empty'
        else
          @kandy_user = @shop.kandy_users.find(params[:kandy_user_id])
          @shop.kandy_user_guest_id = params[:kandy_user_guest_id]
          @shop.template = Template.new
          @shop.widget = Widget.new
          @kandy_user.user = @shop.users.create!(email: email, first_name: params[:first_name], last_name: params[:last_name], password: password, role: User::ADMIN,
                                                 phone_number: params[:phone_number], kandy_user_id: params[:kandy_user_id], invitation_accepted_at: Time.now.utc)
          update_shop_details

          @shop.save
          @kandy_user.save

          setup_webhooks
          setup_script_tags

          redirect_to session['return_url'] || root_url and return
        end
      end
    end

    @kandy_users = @shop.kandy_users.all
    render 'admin_account'
  end

  private

  def update_shop_details
    @shop.initialized = true
    @shop_details = ShopifyAPI::Shop.current
    @shop.time_zone = @shop_details.timezone.match(/\(.*\) (.*)/)[1]
    @shop.email = @shop_details.email
    @shop.phone = @shop_details.phone
  end

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
          {url: webhooks_customer_creation_url, topic: 'customers/create'},
          {url: webhooks_shop_update_url, topic: 'shop/update'}
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

  def shop_params
    params.require(:shop).permit(:id, :kandy_api_key, :kandy_api_secret)
  end

  def load_shop
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
  end
end