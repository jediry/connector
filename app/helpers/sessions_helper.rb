module SessionsHelper
  def log_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def log_out
    self.current_user = nil
    cookies.delete :remember_token
    redirect_to login_url, :notice => 'You have been logged out.'
  end

  def logged_in?
    not current_user.nil?
  end

  def logged_in_admin?
    current_user && current_user.admin?
  end

  def require_logged_in_user
    redirect_to login_url, :notice => 'You must be logged in to view this page. Please log in.' unless logged_in?
  end

  def require_logged_in_admin
    redirect_to login_url, :notice => 'You must be an administrator to view this page. Please log in.' unless logged_in_admin?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
end
