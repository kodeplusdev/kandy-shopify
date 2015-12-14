class Users::ManageController < DeviseController
  before_action :authenticate_user!
  before_action :load_shop, except: [:destroy]

  def index
    @users = @shop.users.all
  end

  def edit
    @user = @shop.users.find(params[:id])
    @kandy_users = @shop.kandy_users.where('id != ? AND (user_id IS NULL OR user_id = ?)', @shop.kandy_user_guest_id, @user.id)
  end

  def invite
    @kandy_users = @shop.kandy_users.where('id != ? AND (user_id IS NULL)', @shop.kandy_user_guest_id)
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

    @kandy_users = @shop.kandy_users.where('id != ? AND (user_id IS NULL)', @shop.kandy_user_guest_id)
    render :invite
  end

  def update
    @user = @shop.users.find(params[:id])
    @kandy_users = @shop.kandy_users.where('id != ? AND (user_id IS NULL OR user_id = ?)', @shop.kandy_user_guest_id, @user.id)

    unless current_user.admin?
      params[:user].delete :role
    end
    if @user.update_attributes(user_params)
      flash[:notice] = 'Updated successfully.'

      new_kandy_user = @shop.kandy_users.find(@user.kandy_user_id)
      new_kandy_user.user = @user
      new_kandy_user.save

      old_kandy_user = @kandy_users.where('id != ? AND user_id = ?', @user.kandy_user_id, @user.id).first
      if old_kandy_user
        old_kandy_user.user = nil
        old_kandy_user.save
      end

    else
      flash[:error] = 'All fields must be valid.'
    end
    render :edit
  end

  def destroy
    @user = User.find(params[:id])
    @kandy_user = @user.kandy_user

    @user.destroy

    @kandy_user.user = nil
    @kandy_user.save

    flash[:notice] = 'User deleted.'
  end

  private

  def load_shop
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
  end

  def user_params
    params.require(:user).permit(:id, :first_name, :last_name, :phone_number, :role, :avatar, :kandy_user_id)
  end
end