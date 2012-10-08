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
        create_sub_tasks @task, true # just_created
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

    respond_to do |format|
      if @task.update_attributes(params[:task])
        create_sub_tasks @task, false # just_created
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
    @task.notes.create({:content => params[:content], :user => current_user })
    if !params[:task_status_id].blank?
      @task.task_status = @task.task_type.task_statuses.find(params[:task_status_id])
    end
    if !params[:user_id].blank?
      @task.user = User.find(params[:user_id])
    end
    
    respond_to do |format|
      if @task.save
        create_sub_tasks @task, false # just_created
        format.html { redirect_to @task, notice: 'Note successfully addded.' }
        format.json { head :no_content }
      else
        format.html { redirect_to @task, notice: 'Error adding note to task.' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

private
  def create_sub_tasks(task, just_created)
    if just_created
      sub_task_types = task.task_type.sub_task_types.where(:task_status_id => nil)
      sub_task_types.each do |stt|
        task.sub_tasks.create(:task_id => task.id, :sub_task_type_id => stt.id)
      end
    end

    sub_task_types = task.task_type.sub_task_types.where(:task_status_id => task.task_status.id)
    sub_task_types.each do |stt|
      task.sub_tasks.create(:task_id => task.id, :sub_task_type_id => stt.id)
    end
  end
end
