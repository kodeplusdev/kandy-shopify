class SmsController < WebhooksController

  def order_creation
    render nothing: true, status: 200
    Thread.new do
      phone = @shop.kandy_phone_number # params[:customer][:default_address][:phone]
      if phone.blank?
        puts 'Unknown phone number' and return
      end

      if send_sms_notify phone, @shop.template.order_creation
        puts "New order notify has been sent to #{phone}" and return
      else
        puts 'New order notify template was empty' and return
      end
    end
  end

  def order_update
    render nothing: true, status: 200
    Thread.new do
      phone = params[:customer][:default_address][:phone]
      if phone.blank?
        puts 'Unknown phone number' and return
      end

      if send_sms_notify phone, @shop.template.order_creation
        puts "Order updated notify has been sent to #{phone}" and return
      else
        puts s 'Order updated notify template was empty' and return
      end
    end
  end

  def order_payment
    render nothing: true, status: 200
    Thread.new do
      if @shop.kandy_phone_number.blank?
        puts 'Unknown phone number' and return
      end

      if send_sms_notify @shop.kandy_phone_number, @shop.template.order_payment
        puts "Order payment notify has been sent to #{@shop.kandy_phone_number}" and return
      else
        puts 'Order payment notify template was empty' and return
      end
    end
  end

  def customer_creation
    render nothing: true, status: 200
    Thread.new do
      if @shop.kandy_phone_number.blank?
        puts 'Unknown phone number' and return
      end

      if send_sms_notify @shop.kandy_phone_number, @shop.template.customer_creation
        puts "New customer notify has been sent to #{@shop.kandy_phone_number}" and return
      else
        puts 'New customer template was empty' and return
      end
    end
  end

  private

  def send_sms_notify(to, template)
    template = Liquid::Template.parse(template)
    text = template.render(params)

    unless text.blank?
      kandy = Kandy.new(api_key: @shop.kandy_api_key, api_secret: @shop.kandy_api_secret, access_token: @shop.kandy_token)
      kandy.send_sms(from: @shop.kandy_phone_number, to: to, text: text)
      return true
    end

    false
  end
end