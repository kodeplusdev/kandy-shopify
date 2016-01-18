class Users::InvitationsController < Devise::InvitationsController
  skip_filter :shopify_session, only: [:edit, :update, :destroy]
  before_action :load_shop, only: [:new, :create]
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # GET /resource/invitation/new
  def new
    self.resource = resource_class.new
    @kandy_users = @shop.kandy_users.where('user_id IS NULL')
    render :new
  end

  # POST /resource/invitation
  def create
    self.resource = invite_resource
    resource_invited = resource.errors.empty?

    yield resource if block_given?

    if resource_invited
      if is_flashing_format? && self.resource.invitation_sent_at
        set_flash_message :notice, :send_instructions, :email => self.resource.email
      end
      respond_with resource, :location => after_invite_path_for(current_inviter)
    else
      @kandy_users = @shop.kandy_users.where('user_id IS NULL')
      respond_with_navigational(resource) { render :new }
    end
  end

  def edit
    set_minimum_password_length if respond_to? :set_minimum_password_length
    resource.invitation_token = params[:invitation_token]
    render :edit, layout: 'application'
  end

  # PUT /resource/invitation
  def update
    raw_invitation_token = update_resource_params[:invitation_token]
    self.resource = accept_resource
    invitation_accepted = resource.errors.empty?

    yield resource if block_given?

    if invitation_accepted
      if Devise.allow_insecure_sign_in_after_accept
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message :notice, flash_message if is_flashing_format?
        sign_in(resource_name, resource)
        # respond_with resource, :location => after_accept_path_for(resource)
      else
        set_flash_message :notice, :updated_not_active if is_flashing_format?
        # respond_with resource, :location => new_session_path(resource_name)
      end
      redirect_to "https://#{@shop_session.url}/admin/apps/#{ShopifyApp.configuration.api_key}"
    else
      resource.invitation_token = raw_invitation_token
      respond_with_navigational(resource) { render :edit, layout: 'application' }
    end
  end

  private

  def load_shop
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:invite).concat [:role, :shop_id, :kandy_user_id]
    # Only add some parameters
    devise_parameter_sanitizer.for(:accept_invitation).concat [:first_name, :last_name, :phone_number]
    # Override accepted parameters
    # devise_parameter_sanitizer.for(:accept_invitation) do |u|
    #   u.permit(:first_name, :last_name, :phone, :password, :password_confirmation,
    #            :invitation_token)
    # end
  end
end
