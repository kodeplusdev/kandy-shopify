class WidgetsController < ApplicationController
  layout 'embedded_app'
  around_filter :shopify_session
  before_action :set_widget, only: [:show, :edit, :update, :destroy]

  def index
    @widgets = Widget.all
  end

  def show
  end

  def new
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
    @widget = @shop.widgets.new
    @widget.json_string = Widget.DEFAULT
    render 'form'
  end

  def edit
    puts OpenStruct.new(@widget.json_string_open_struct.in_chat)
    render 'form'
  end

  def create
    @widget = Widget.new(widget_params)

    if @widget.save
      redirect_to widgets_path, notice: 'Widget was successfully created.'
    else
      render 'form'
    end
  end

  def update
    if @widget.update(widget_params)
      redirect_to widgets_path, notice: 'Widget was successfully updated.'
    else
      render 'form'
    end
  end

  def destroy
    @widget.destroy
    redirect_to widgets_url, notice: 'Widget was successfully destroyed.'
  end

  def preview

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_widget
    @widget = Widget.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def widget_params
    params.require(:widget).permit(:id, :name, :enabled, :color, :shop_id,
                                   json_string: [
                                       collapse: [:title, :position, :type, :image, :custom_image_url, :horizontal, :vertical, :scale, :image_in_front_of_tab, :page_load, :show_widget_hide_button],
                                       start_chat: [:title, :intro_text, :request_button, :ask_for_name, :ask_for_name_text, :ask_for_email, :ask_for_email_text, :ask_for_question, :ask_for_question_text, :ask_for_department],
                                       no_operators: [:title, :action, :message, :central_email, :email_intro, :name, :email, :question, :email_sent_text, :send_button],
                                       in_chat: [:title, :message, :no_operators, :greeting, :connecting, :typing, :joined_chat, :send_message],
                                       chat_close: [:title, :chat_closed, :download, :ask_for_rating],
                                       error_messages: [:name_required, :email_validation, :no_operator_required]
                                   ])
  end
end
