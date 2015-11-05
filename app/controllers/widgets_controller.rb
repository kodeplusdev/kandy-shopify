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
    @widget = Widget.new
    render 'form'
  end

  def edit
    render 'form'
  end

  def create
    wp = widget_params
    wp[:widget][:json_string] = params[:json_string].to_json

    @widget = Widget.new(wp)

    if @widget.save
      redirect_to widgets_path, notice: 'Widget was successfully created.'
    else
      render :new
    end
  end

  def update
    wp = widget_params
    wp[:widget][:json_string] = params[:json_string].to_json
    if @widget.update(wp)
      redirect_to widgets_path, notice: 'Widget was successfully updated.'
    else
      render :edit
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
      params.require(:widget).permit(:name, :enabled, :color, :json_string, :shop_id)
    end
end
