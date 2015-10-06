class SmsController < WebhooksController

  def order_creation
    phone = params[:customer][:default_address][:phone]
    if phone.blank?
      render text: 'Unknown phone number', status: 200 and return
    end

    if send_sms_notify phone, @shop.template.order_creation
      render text: "New order notify has been sent to #{phone}", status: 200
    else
      render text: 'New order notify template was empty', status: 200
    end
  end

  def order_update
    phone = params[:customer][:default_address][:phone]
    if phone.blank?
      render text: 'Unknown phone number', status: 200 and return
    end

    if send_sms_notify phone, @shop.template.order_creation
      render text: "Order updated notify has been sent to #{phone}", status: 200
    else
      render text: 'Order updated notify template was empty', status: 200
    end
  end

  def order_payment
    if @shop.kandy_phone_number.blank?
      render text: 'Unknown phone number', status: 200 and return
    end

    if send_sms_notify @shop.kandy_phone_number, @shop.template.order_payment
      render text: "Order payment notify has been sent to #{@shop.kandy_phone_number}", status: 200
    else
      render text: 'Order payment notify template was empty', status: 200
    end
  end

  def customer_creation
    if @shop.kandy_phone_number.blank?
      render text: 'Unknown phone number', status: 200 and return
    end

    if send_sms_notify @shop.kandy_phone_number, @shop.template.customer_creation
      render text: "New customer notify has been sent to #{@shop.kandy_phone_number}", status: 200
    else
      render text: 'New customer template was empty', status: 200
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