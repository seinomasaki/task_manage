class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :user_logged_in?
  before_action :admin_user?

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_oder}" : nil
    direction = (column == sort_column && sort_oder == "asc") ? "desc" : "asc"
    link_to title, {:sort => column, :oder => direction}, {:class => css_class}
  end

  def user_logged_in?
    if session[:user_id]
      begin
        @current_user = User.find_by(id: session[:user_id])
      rescue ActiveRecord::RecordNotFound
        reset_user_session
      end
    end
    return if @current_user
    flash[:error] = t('activerecord.attributes.flash.loged')
    redirect_to new_session_path
  end

  def reset_user_session
    session[:user_id] = nil
    @current_user = nil
  end

  def admin_user?
    pp session[:user_id]
    if @current_user.admin == false
      flash[:error] = I18n.t('activerecord.attributes.flash.unauthorized')
      redirect_to summaries_path
    end
  end
end