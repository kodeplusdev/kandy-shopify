class Webhooks::SmsController < WebhooksController

  # POST /webhooks/sms/order-creation
  def order_creation
    render nothing: true, status: 200
    Thread.new do
      admin = @shop.users.admin.first

      phone = params[:customer][:default_address][:phone]
      if phone.blank?
        puts 'Unknown phone number' and return
      end

      if send_sms_notify admin, phone, @shop.template.order_creation
        puts "New order notify has been sent to #{phone}" and return
      else
        puts 'New order notify template was empty' and return
      end
    end
  end

  # POST /webhooks/sms/order-update
  def order_update
    render nothing: true, status: 200
    Thread.new do
      admin = @shop.users.admin.first

      phone = params[:customer][:default_address][:phone]
      if phone.blank?
        puts 'Unknown phone number' and return
      end

      if send_sms_notify admin, phone, @shop.template.order_update
        puts "Order updated notify has been sent to #{phone}" and return
      else
        puts s 'Order updated notify template was empty' and return
      end
    end
  end

  # POST /webhooks/sms/order-payment
  def order_payment
    render nothing: true, status: 200
    Thread.new do
      admin = @shop.users.admin.first
      unless @shop.phone.blank?
        puts 'Unknown phone number' and return
      end

      if send_sms_notify admin, @shop.phone, @shop.template.order_payment
        puts "Order payment notify has been sent to #{admin.phone_number}" and return
      else
        puts 'Order payment notify template was empty' and return
      end
    end
  end

  # POST /webhooks/sms/customer-creation
  def customer_creation
    render nothing: true, status: 200
    Thread.new do
      admin = @shop.users.admin.first
      unless @shop.phone
        puts 'Unknown phone number' and return
      end

      if send_sms_notify admin, @shop.phone, @shop.template.customer_creation
        puts "New customer notify has been sent to #{admin.phone_number}" and return
      else
        puts 'New customer template was empty' and return
      end
    end
  end

  private

  def send_sms_notify(admin, to, template)
    unless admin
      puts 'Unknown phone number' and return
    end
    # render template with parameters recieved
    params[:host] = @shop.shopify_domain
    template = Liquid::Template.parse(template)
    text = template.render(params)

    # remove plus symbol from phone number
    from = admin.phone_number.split('+').last
    to = to.split('+').last

    unless text.blank?
      kandy = Kandy.new(domain_api_key: @shop.kandy_api_key, domain_api_secret: @shop.kandy_api_secret)
      kandy.send_sms(username: admin.kandy_user.username, password: admin.kandy_user.password, source: from, destination: to, text: text)
      return true
    end

    false
  end
end