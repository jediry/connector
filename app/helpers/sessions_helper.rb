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

  def authenticated?
    !current_user.nil?
  end

  def logged_in?
    authenticated? && !current_user.must_change_password
  end

  def logged_in_admin?
    current_user && current_user.admin?
  end

  # A few bits of functionality are tied only to the 'admin' account, which people should generally not be using.
  def logged_in_super_admin?
    current_user.username == 'admin'
  end

  def require_authenticated_user
    redirect_to login_path, :notice => 'You must be logged in to view this page. Please log in.' unless authenticated?
  end

  def require_logged_in_user
    require_authenticated_user
    if authenticated?
      redirect_to password_user_path(current_user), :notice => 'You must change your password first.' unless !current_user.must_change_password
    end
  end

  def require_logged_in_admin
    require_logged_in_user
    if logged_in?
      redirect_to home_path, :notice => 'You must be an administrator to view this page.' unless logged_in_admin?
    end
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
end
