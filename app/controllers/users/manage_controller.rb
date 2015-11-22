class Users::ManageController < DeviseController
  before_action :authenticate_user!

  def index
    @shop = Shop.find_by_shopify_domain(@shop_session.url)
    @users = @shop.users.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def invite
  end

  def new_invite
    email = params[:email]
    first_name = params[:first_name] || ''
    last_name = params[:last_name] || ''

    if email.blank? || !(email =~ /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
      flash[:error] = 'A valid email is required.'
      render :invite
    else
      @shop = Shop.find_by_shopify_domain(params[:shop])

      @shop.users.invite!(email: email, first_name: first_name, last_name: last_name, role: User::OPERATOR)

      flash.now[:notice] = 'An invitation email has been sent.'
      redirect_to users_manage_url
    end
  end

  def update
    @user = User.find(params[:id])
    unless current_user.admin?
      params[:user].delete :role
    end
    if @user.update_attributes(user_params)
      flash[:notice] = 'Updated successful.'
    else
      flash[:error] = 'All fields must be valid.'
    end
    render :edit
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = 'User deleted.'
  end

  private

  def user_params
    params.require(:user).permit(:id, :first_name, :last_name, :phone_number, :role, :avatar)
  end
end