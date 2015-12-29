class Users::InvitationsController < Devise::InvitationsController
  layout 'application', only: [:edit, :update, :destroy]
  skip_filter :shopify_session, only: [:edit, :update, :destroy]
end
