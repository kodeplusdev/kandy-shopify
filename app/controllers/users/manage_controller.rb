class Users::ManageController < DeviseController
  before_action :authenticate_user!
  before_action :load_shop, except: [:destroy]

  def index
    @users = @shop.users.all
  end

  def edit
    @user = @shop.users.find(params[:id])
    @kandy_users = @shop.kandy_users.where('user_id IS NULL OR user_id = ?', @user.id)
  end

  def invite
    @kandy_users = @shop.kandy_users.where('user_id IS NULL')
  end

  def new_invite
    email = params[:email]

    if email.blank? || !(email =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      flash[:error] = 'A valid email is required.'
    else
      if params[:kandy_user_id].blank?
        flash[:error] = 'A kandy user is required. Create one if empty.'
      else
        kandy_user = @shop.kandy_users.find(params[:kandy_user_id])
        kandy_user.user = @shop.users.invite!(email: email, first_name: params[:first_name], last_name: params[:last_name], role: User::OPERATOR, kandy_user_id: kandy_user.id)
        kandy_user.save

        flash.now[:notice] = 'An invitation email has been sent.'
        redirect_to users_manage_url and return
      end
    end

    @kandy_users = @shop.kandy_users.where('user_id IS NULL')
    render :invite
  end

  def update
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
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
    @user = @shop.users.find(params[:id])
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