class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_admin]

  def index
    @users = User.includes(:loyalty_cards, :orders)
                 .order(created_at: :desc)
                 .page(params[:page])
    @users = @users.where(admin: true) if params[:filter] == 'admins'
    @users = @users.where(admin: false) if params[:filter] == 'customers'
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @users = @users.where(
        "first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?",
        search_term, search_term, search_term
      )
    end
  end

  def show
    @user_stats = {
      total_orders: @user.orders.count,
      total_spent: @user.orders.sum(:total_amount),
      loyalty_cards: @user.loyalty_cards.count,
      completed_cards: @user.loyalty_cards.completed.count,
      pending_receipts: @user.receipt_uploads.joins(:loyalty_punch)
                                            .where(loyalty_punches: { is_approved: false })
                                            .count
    }
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user), notice: 'User created successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'User updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: 'You cannot delete your own account.'
      return
    end
    @user.destroy
    redirect_to admin_users_path, notice: 'User deleted successfully.'
  end

  def toggle_admin
    if @user == current_user
      redirect_to admin_users_path, alert: 'You cannot change your own admin status.'
      return
    
    @user.update!(admin: !@user.admin?)
    status = @user.admin? ? 'granted' : 'revoked'
    redirect_to admin_user_path(@user), notice: "Admin access #{status} for #{@user.full_name}."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :admin)
  end
end