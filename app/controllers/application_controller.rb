class ApplicationController < ActionController::Base
  include ShopifyApp::Controller
  layout 'embedded_app'
  around_filter :shopify_session
  around_filter :set_time_zone, :if => :shop_session
  protect_from_forgery

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path(shop: @shop_session.url)
  end

  def set_time_zone(&block)
    Time.use_zone(@shop_session.time_zone, &block)
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html {
        flash[:error] = 'Not allowed to do this action.'
        redirect_to request.referer.include?(request.path) ? root_path : request.referer
      }
      format.json {render status: :forbidden, plain: 'Not allowed to do this action.'}
    end
  end

  def authenticate_user!(opts={})
    if @shop_session.blank? || @shop_session.initialized
      super(opts)
    else
      redirect_to app_installed_path(request.query_parameters) and return
    end
  end
end
