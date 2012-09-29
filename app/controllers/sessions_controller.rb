class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_username(params[:session][:username].downcase)
    if user and user.authenticate(params[:session][:password])
      # Successfully authenticated
      if user.active
        # You may pass
        log_in user
        redirect_to home_path
      else
        flash.now[:error] = 'Your user account is inactive, so you may not log in.'
        render 'new'
      end
    else
      # Uh oh! Wrong u/p, dummy!
      flash.now[:error] = 'Invalid username/password'
      render 'new'
    end
  end

  def destroy
    log_out
  end
end
