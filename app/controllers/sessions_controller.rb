class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_username(params[:session][:username].downcase)
    if user and user.authenticate(params[:session][:password])
      # Successfully authenticated. You may pass.
      log_in user
      redirect_to my_tasks_path
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
