class GroupsController < ApplicationController
  before_filter :require_logged_in_user

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  # POST /groups/1/members
  # POST /groups/1/members.json
  def add_member
    @group = Group.find(params[:group_id])
    @group.members << Person.find(params[:person_id])

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Person successfully addded to group.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @group, notice: 'Error adding person to group.' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1/member/3
  # PUT /groups/1/member/3.json
  def update_member
    @membership = GroupMembership.where(:group_id => params[:group_id]).where(:person_id => params[:person_id]).first

    respond_to do |format|
      if @membership.update_attributes(params[:group_membership])
        format.html { redirect_to @membership.group, notice: 'Group membership successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @membership.group, notice: 'Error updating group membership.' }
        format.json { render json: @membership.group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1/member/3
  # DELETE /groups/1/member/3.json
  def remove_member
    @group = Group.find(params[:group_id])
    @group.members.delete Person.find(params[:person_id])

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Person successfully removed from group.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @group, notice: 'Error removing person from group.' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end
end
