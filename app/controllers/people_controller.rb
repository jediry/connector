class PeopleController < ApplicationController
  before_filter :require_logged_in_user

  # GET /people
  # GET /people.xlsx
  # GET /people.json
  def index
    @query = PeopleQuery.new(params[:query])
    @people = @query.find

    respond_to do |format|
      format.html # index.html.erb
      format.xlsx # index.xlsx.axlsx
      format.json { render json: @people }
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/new
  # GET /people/new.json
  def new
    @person = Person.new
    @person.build_if_missing

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
    @person.build_if_missing
  end

  # POST /people
  # POST /people.json
  def create

    Person.sanitize_attributes params[:person]

    @person = Person.new(params[:person])

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render json: @person, status: :created, location: @person }
      else
        format.html { @person.build_if_missing; render action: "new" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.json
  def update
    @person = Person.find(params[:id])

    Person.sanitize_attributes params[:person]

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { @person.build_if_missing; render action: "edit" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url }
      format.json { head :no_content }
    end
  end

  # POST /people/1/groups
  # POST /people/1/groups.json
  def add_to_group
    @person = Person.find(params[:person_id])
    @person.groups << Group.find(params[:group_id])

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person successfully addded to group.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @person, notice: 'Error adding person to group.' }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1/group/3
  # DELETE /people/1/group/3.json
  def remove_from_group
    @person = Person.find(params[:person_id])
    @group = Group.find(params[:group_id])
    @membership = @group.group_memberships.find_by_person_id(params[:person_id])
    if !@membership.tasks.empty?
      redirect_to @person, notice: 'Error: this person has tasks assigned to him/her for this group, so cannot be removed fromt he group. Reassign his/her tasks to another group contact before removing.'
    else
      @group.members.delete @person

      respond_to do |format|
        if @group.save
          format.html { redirect_to @person, notice: 'Person successfully removed from group.' }
          format.json { head :no_content }
        else
          format.html { redirect_to @person, notice: 'Error removing person from group.' }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
      end
    end
  end
end
