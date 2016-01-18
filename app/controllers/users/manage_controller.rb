class Users::ManageController < DeviseController
  before_action :authenticate_user!
  before_action :load_shop, except: [:destroy]

  def index
    authorize! :manage, :user

    @users = @shop.users.all
  end

  def edit
    authorize! :update, :user

    @user = @shop.users.find(params[:id])
    @kandy_users = @shop.kandy_users.where('user_id IS NULL OR user_id = ?', @user.id)
  end

  def update
    authorize! :update, :user

    @user = @shop.users.find(params[:id])
    @kandy_users = @shop.kandy_users.where('user_id IS NULL OR user_id = ?', @user.id)
    if params[:user][:kandy_user_id].blank?
      flash[:error] = 'Please select a kandy user.'
    else
      unless current_user.admin?
        params[:user].delete :role
      end
      if @user.update_attributes(user_params)
        flash[:notice] = 'Updated successfully.'
      else
        flash[:error] = 'All fields must be valid.'
      end
    end

    render :edit
  end

  def destroy
    authorize! :destroy, :user

    @shop = Shop.find_by_shopify_domain(@shop_session.url)
    @user = @shop.users.find(params[:id])
    if @user.kandy_user
      @user.kandy_user = nil
    end
    @user.destroy
    flash[:notice] = 'User deleted.'
  rescue ActiveRecord::RecordNotFound
      flash[:error] = 'User not found.'
  ensure
    redirect_to action: :index
  end

  private

  def load_shop
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
  end

  def user_params
    params.require(:user).permit(:id, :first_name, :last_name, :phone_number, :role, :avatar, :kandy_user_id)
  end
end