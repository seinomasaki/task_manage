module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def log_out
    session[:user_id] = nil
    @current_user = nil
  end

  def logged_in?
    @current_user.present?
  end
end
