class PreferencesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_shop, except: [:index, :update]

  def index
  end

  def update
    authorize! :update, :api_key unless params[:shop][:kandy_api_key].blank?
    authorize! :update, :widget unless params[:shop][:widget_attributes].blank?
    authorize! :update, :template unless params[:shop][:template_attributes].blank?

    @shop = Shop.find(params[:shop][:id])
    if params[:shop][:kandy_api_key] == nil && params[:shop][:kandy_api_secret] == nil
      if @shop.update_attributes(shop_params)
        flash[:notice] = 'Updated successful'
      else
        flash[:error] = @shop.errors.full_messages.first
      end
    else
      if !params[:shop][:kandy_api_key].blank? || !params[:shop][:kandy_api_secret].blank?
        old_api_key = @shop.kandy_api_key
        old_api_secret = @shop.kandy_api_secret
        if old_api_key != params[:shop][:kandy_api_key] || old_api_secret != params[:shop][:kandy_api_secret]
          kandy = Kandy.new(domain_api_key: @shop.kandy_api_key, domain_api_secret: @shop.kandy_api_secret)
          users = kandy.domain_users
          if users.blank? || users.size < 1
            flash[:error] = 'Your kandy account should have least 1 users.'
          else
            if @shop.update_attributes(shop_params)
              @shop.kandy_users.destroy_all
              users.each do |u|
                @shop.kandy_users.create(username: u.user_id, email: u.user_email, password: u.user_password,
                                         first_name: u.user_first_name, last_name: u.user_last_name, phone_number: u.user_phone_number,
                                         api_key: u.user_api_key, api_secret: u.user_api_secret, country_code: u.user_country_code, domain_name: u.domain_name)
              end
              flash[:notice] = 'Please setup kandy user for your account and other accounts.'
              redirect_to users_manage_edit_path(current_user) and return
            else
              flash[:error] = @shop.errors.full_messages.first
            end
          end
        end
      else
        flash[:error] = 'Please enter valid kandy api keys.'
      end
    end

    redirect_to params[:back_url] and return
  end

  def api_keys
    authorize! :update, :api_key
  end

  def sms_alert_templates
    authorize! :update, :template
  end

  def chat_box_widget
    authorize! :update, :widget
  end

  def chat_box_widget_preview
    authorize! :update, :widget

    @shop = Shop.find_by_shopify_domain(@shop_session.url)
    render layout: 'application'
  end

  private

  def load_shop
    @shop = Shop.find_by_shopify_domain(params[:shop] || @shop_session.url)
  end

  def shop_params
    params.require(:shop).permit(:id, :kandy_api_key, :kandy_api_secret, :kandy_username, :kandy_password, :kandy_username_guest, :kandy_password_guest,
                                 template_attributes: [:id, :order_creation, :order_update, :order_payment, :customer_creation],
                                 widget_attributes: [:id, :name, :enabled, :color,
                                                     json_string: [
                                                         collapse: [:title, :position, :type, :image, :custom_image_url, :horizontal, :vertical, :scale, :image_in_front_of_tab, :page_load, :show_widget_hide_button],
                                                         start_chat: [:title, :intro_text, :request_button, :ask_for_name, :ask_for_name_text, :ask_for_email, :ask_for_email_text, :ask_for_question, :ask_for_question_text, :ask_for_department],
                                                         no_operators: [:title, :action, :message, :central_email, :email_intro, :name, :email, :question, :email_sent_text, :send_button],
                                                         in_chat: [:title, :message, :no_operators, :greeting, :connecting, :typing, :joined_chat, :left_chat, :closed_chat, :start_message, :send_message],
                                                         chat_close: [:title, :chat_closed, :download, :downloadable, :ask_for_rating, :rating_thanks],
                                                         error_messages: [:name_required, :email_valid, :no_operator_required]
                                                     ]])
  end
end