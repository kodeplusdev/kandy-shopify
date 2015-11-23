class PreferencesController < ApplicationController
  before_action :authenticate_user!
  before_action :shop, except: [:index, :update]

  def index
  end

  def update
    if params[:shop][:kandy_password].blank?
      params[:shop].delete :kandy_password
    end
    if params[:shop][:kandy_password_guest].blank?
      params[:shop].delete :kandy_password_guest
    end
    @shop = Shop.find(params[:shop][:id])
    if @shop.update_attributes(shop_params)
      # unless @shop.kandy_password.blank?
      #   kandy = Kandy.new(api_key: @shop.kandy_api_key, api_secret: @shop.kandy_api_secret)
      #
      #   @shop.kandy_username = @shop.kandy_username.split('@').first unless @shop.kandy_username.blank?
      #   res = kandy.get_user_access_token(@shop.kandy_username, @shop.kandy_password)
      #
      #   if res['status'] == 1
      #     flash[:error] = res['message']
      #   else
      #     unless @shop.kandy_password_test.blank?
      #       kandy = Kandy.new(api_key: @shop.kandy_api_key, api_secret: @shop.kandy_api_secret)
      #
      #       @shop.kandy_username_test = @shop.kandy_username_test.split('@').first unless @shop.kandy_username_test.blank?
      #       res = kandy.get_user_access_token(@shop.kandy_username_test, @shop.kandy_password_test)
      #
      #       if res['status'] == 1
      #         flash[:error] = res['message']
      #       else
      #         @shop.kandy_access_token_test = res['result']['user_access_token']
      #         @shop.save
      #         flash[:notice] = 'Updated successful'
      #       end
      #     else
      #       @shop.save
      #       flash[:notice] = 'Updated successful'
      #     end
      #   end
      # else
      flash[:notice] = 'Updated successful'
      # end
    else
      flash[:error] = @shop.errors.full_messages.first
    end
    redirect_to params[:back_url]
  end

  def api_keys
  end

  def kandy_account
  end

  def sms_alert_templates
  end

  def chat_box_widget
    if @shop.widget.json_string.blank?
      @shop.widget.json_string = Widget.DEFAULT
    end
  end

  def chat_box_widget_preview
  end

  private

  def shop
    @shop = Shop.find_by_shopify_domain(params[:shop] || @shop_session.url)
  end

  def shop_params
    params.require(:shop).permit(:id, :kandy_api_key, :kandy_api_secret, :kandy_username, :kandy_password, :kandy_username_guest, :kandy_password_guest,
                                 template_attributes: [:id, :order_creation, :order_update, :order_payment, :customer_creation],
                                 profile_attributes: [:id, :first_name, :last_name, :phone_number, :email],
                                 widget_attributes: [:id, :name, :enabled, :color,
                                                     json_string: [
                                                         collapse: [:title, :position, :type, :image, :custom_image_url, :horizontal, :vertical, :scale, :image_in_front_of_tab, :page_load, :show_widget_hide_button],
                                                         start_chat: [:title, :intro_text, :request_button, :ask_for_name, :ask_for_name_text, :ask_for_email, :ask_for_email_text, :ask_for_question, :ask_for_question_text, :ask_for_department],
                                                         no_operators: [:title, :action, :message, :central_email, :email_intro, :name, :email, :question, :email_sent_text, :send_button],
                                                         in_chat: [:title, :message, :no_operators, :greeting, :connecting, :typing, :joined_chat, :left_chat, :closed_chat, :start_message, :send_message],
                                                         chat_close: [:title, :chat_closed, :download, :ask_for_rating],
                                                         error_messages: [:name_required, :email_validation, :no_operator_required]
                                                     ]])
  end
end