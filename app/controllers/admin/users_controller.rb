class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :admin_user?

  layout 'admin'

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t('activerecord.attributes.flash.update')
      redirect_to admin_users_path
    else
      flash[:warning] = @user.errors.full_messages.each
      render 'admin/users/edit'
    end
  end

  def show; end

  def destroy
    @user.destroy
    flash[:success] = t('activerecord.attributes.flash.destroy')
    redirect_to admin_users_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :general, :admin, :password_confirmation, :profile_image)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
