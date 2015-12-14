module DeviseHelper

  def devise_error_messages!
    return '' if resource.errors.empty?
    flash[:error] = resource.errors.full_messages.first
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end
end