class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: Tasks.all }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new
    @task.person = Person.find(params[:person_id])
    @task.task_type = TaskType.find(params[:task_type_id])
    @task.task_status = @task.task_type.task_statuses.where(:start => true).first

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        create_sub_tasks @task, nil # previous_status
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])
    old_status = @task.task_status

    respond_to do |format|
      if @task.update_attributes(params[:task])
        create_sub_tasks @task, old_status
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end

  # POST /tasks/1/notes
  # POST /tasks/1/notes.json
  def add_note
    @task = Task.find(params[:task_id])
    old_status = @task.task_status

    @task.notes.create({:content => params[:content], :user => current_user })
    if !params[:task_status_id].blank?
      @task.task_status = @task.task_type.task_statuses.find(params[:task_status_id])
    end
    if !params[:user_id].blank?
      @task.user = User.find(params[:user_id])
    end

    # Update our 'last attempt' date as well as the 'failed attempts' count
    if !params[:successful_contact].blank? || !params[:failed_contact].blank?
      @task.last_contact_attempt_made_at = Time.current
      if !params[:successful_contact].blank?
        @task.consecutive_failed_contact_attempts = 0
      else
        @task.consecutive_failed_contact_attempts += 1
      end
    end

    # Update the 'attempt next' date
    if !params[:attempt_next_contact_by].blank?
      @task.attempt_next_contact_by = Time.parse(params[:attempt_next_contact_by])
    elsif !params[:attempt_next_contact_in_days].blank?
      @task.attempt_next_contact_by = Time.current.advance(:days => params[:attempt_next_contact_in_days].to_i)
    end

    respond_to do |format|
      if @task.save
        create_sub_tasks @task, old_status
        format.html { redirect_to @task, notice: 'Note successfully addded.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @task, notice: 'Error adding note to task.' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

private
  def create_sub_tasks(task, previous_status)
    # If we're just now creating this task, create any on-creation sub-tasks
    if previous_status.nil?
      sub_task_types = task.task_type.sub_task_types.where(:task_status_id => nil)
      sub_task_types.each do |stt|
        create_sub_task task, stt
      end
    end

    # if the current status is different from the old one (including if the old status was nil), create any new sub-tasks
    if previous_status != task.task_status
      sub_task_types = task.task_type.sub_task_types.where(:task_status_id => task.task_status.id)
      sub_task_types.each do |stt|
        create_sub_task task, stt
      end
    end
  end

  # Create a sub-task of the specified type, if it doesn't already exist
  def create_sub_task(task, sub_task_type)
    if task.sub_tasks.where(:sub_task_type_id => sub_task_type.id).empty?
      task.sub_tasks.create(:task_id => task.id, :sub_task_type_id => sub_task_type.id)
    end
  end
end
