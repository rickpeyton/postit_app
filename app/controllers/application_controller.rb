class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?, :admin?, :current_user_time_zone

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def current_user_time_zone
    if logged_in?
      @current_user.time_zone
    else
      Time.zone
    end
  end

  def admin?
    @current_user.role == 'admin' ? true : false
  end


  def require_user
    access_denied unless logged_in?
  end

  def require_admin
    access_denied unless logged_in? && admin?
  end

  def access_denied
    flash[:error] = 'You do not have permission to do that.'
    redirect_to login_path
  end
end
