class ChatWidgetsController < ApplicationController
  layout 'embedded_app'
  around_filter :shopify_session
  before_action :set_chat_widget, only: [:show, :edit, :update, :destroy]

  def index
    @chat_widgets = ChatWidget.all
  end

  def show
  end

  def new
    @chat_widget = ChatWidget.new
  end

  def edit
  end

  def create
    @chat_widget = ChatWidget.new(chat_widget_params)

    if @chat_widget.save
      redirect_to @chat_widget, notice: 'Chat widget was successfully created.'
    else
      render :new
    end
  end

  def update
    if @chat_widget.update(chat_widget_params)
      redirect_to @chat_widget, notice: 'Chat widget was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @chat_widget.destroy
    redirect_to chat_widgets_url, notice: 'Chat widget was successfully destroyed.'
  end

  def widget_preview
    render layout: 'application'
  end

  private
    def set_chat_widget
      @chat_widget = ChatWidget.find(params[:id])
    end

    def chat_widget_params
      params.require(:chat_widget).permit(:name, :enabled, :json_string, :shop_id)
    end
end
