class SessionsController < ApplicationController
  before_action :require_log_in!, only: [:destroy]
  skip_before_action :user_logged_in?, only: [:new, :create]
  skip_before_action :admin_user?

  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = t('activerecord.attributes.flash.login')
      if user.admin
        redirect_to admin_summaries_path
      else
        redirect_to summaries_path
      end
    else
      flash[:error] = t('activerecord.attributes.flash.failure')
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:success] = t('activerecord.attributes.flash.logout')
    redirect_to new_session_path
  end

  private
  def require_log_in!
    redirect_to new_sessions_path unless logged_in?
  end
end
