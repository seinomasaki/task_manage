class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update]
  before_action :user_logged_in?, only: %i[index show edit update]
  before_action :my_profile?, only: %i[edit show]
  skip_before_action :admin_user?

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t('activerecord.attributes.flash.create')
      redirect_to new_session_path
    else
      flash[:warning] = @user.errors.full_messages.each
      render 'new'
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t('activerecord.attributes.flash.update')
      redirect_to root_path
    else
      flash[:warning] = @user.errors.full_messages.each
      render 'edit'
    end
  end

  def show; end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :general, :password_confirmation, :profile_image)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def my_profile?
    if @current_user.id != @user[:id] && !@current_user.admin?
      flash[:error] = '不正なアクセスを確認しました。'
      redirect_to users_path
    end
  end
end
