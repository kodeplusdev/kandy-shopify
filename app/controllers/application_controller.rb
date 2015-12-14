class ApplicationController < ActionController::Base
  include ShopifyApp::Controller
  layout 'embedded_app'
  around_filter :shopify_session
  protect_from_forgery

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path(shop: @shop_session.url)
  end

  def admin_only!
    unless current_user.admin?
      redirect_to :back, error: 'Access denied.'
    end
  end

  def superuser_only!
    unless current_user.superuser? && current_user.admin?
      redirect_to :back, error: 'Access denied.'
    end
  end

  def operator_only!
    unless current_user.operator? && current_user.superuser? && current_user.admin?
      redirect_to :back, error: 'Access denied.'
    end
  end

  def error
    raise 'Error'
  end

  def authenticate_user!(opts={})
    if session[:initialized].blank?
      @shop = Shop.find_by_shopify_domain(@shop_session.url)
      unless @shop.blank?
        if @shop.initialized
          session[:initialized] = 1
          super(opts)
        else
          redirect_to app_installed_path(request.query_parameters)
        end
      else
        super(opts)
      end
    else
      super(opts)
    end
  end
end
