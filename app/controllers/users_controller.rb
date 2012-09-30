class UsersController < ApplicationController
  before_filter :require_authenticated_user, :only => [:update, :password]
  before_filter :require_logged_in_admin, :only => [:new, :create, :destroy]
  before_filter :require_current_user_or_admin, :only => [:update, :password]
  before_filter :require_logged_in_user, :except => [:update, :password]

  # GET /
  def home
    respond_to do |format|
      format.html # home.html.erb
    end
  end

  # GET /users/1/password
  def password
    @user = User.find(params[:id])
  end

  # GET /users
  # GET /users.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: User.all }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @user.build_person

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    # If no password was provided, default to the username, but require the user to change on next login
    if params[:user][:password].blank? and params[:user][:password].blank?
      @user.password = params[:user][:username]
      @user.password_confirmation = params[:user][:username]
      @user.must_change_password = true
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    # Non-admins shouldn't be able to make themselves admins...that would be less than awesome
    if !logged_in_admin?
      params[:user][:admin] = false
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  # GET /todo
  def todo
  end

private
  # Only admins get access to users besides themselves
  def require_current_user_or_admin
    if !current_user.admin
      redirect_to home_path, :notice => 'Only administrators may edit other people\'s user accounts' unless current_user.id == params[:id].to_i
    end
  end
end
