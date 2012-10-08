class SubTaskTypesController < ApplicationController
  # GET /task_types/1/sub_task_types
  # GET /task_types/1/sub_task_types.json
  def index
    @task_type = TaskType.find(params[:task_type_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @task_type.sub_task_types.all }
    end
  end

  # GET /task_types/1/sub_task_types/1
  # GET /task_types/1/sub_task_types/1.json
  def show
    @task_type = TaskType.find(params[:task_type_id])
    @sub_task_type = @task_type.sub_task_types.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sub_task_type }
    end
  end

  # GET /task_types/1/sub_task_types/new
  # GET /task_types/1/sub_task_types/new.json
  def new
    @task_type = TaskType.find(params[:task_type_id])
    @sub_task_type = @task_type.sub_task_types.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sub_task_type }
    end
  end

  # GET /task_types/1/sub_task_types/1/edit
  def edit
    @task_type = TaskType.find(params[:task_type_id])
    @sub_task_type = @task_type.sub_task_types.find(params[:id])
  end

  # POST /task_types/1/sub_task_types
  # POST /task_types/1/sub_task_types.json
  def create
    @task_type = TaskType.find(params[:task_type_id])
    @sub_task_type = SubTaskType.new(params[:sub_task_type])
    @task_type.sub_task_types << @sub_task_type

    respond_to do |format|
      if @sub_task_type.save
        format.html { redirect_to [@task_type, @sub_task_type], notice: 'Sub task type was successfully created.' }
        format.json { render json: @sub_task_type, status: :created, location: @sub_task_type }
      else
        format.html { render action: "new" }
        format.json { render json: @sub_task_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /task_types/1/sub_task_types/1
  # PUT /task_types/1/sub_task_types/1.json
  def update
    @task_type = TaskType.find(params[:task_type_id])
    @sub_task_type = @task_type.sub_task_types.find(params[:id])

    respond_to do |format|
      if @sub_task_type.update_attributes(params[:sub_task_type])
        format.html { redirect_to [@task_type, @sub_task_type], notice: 'Sub task type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sub_task_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_types/1/sub_task_types/1
  # DELETE /task_types/1/sub_task_types/1.json
  def destroy
    @task_type = TaskType.find(params[:task_type_id])
    @sub_task_type = @task_type.sub_task_types.find(params[:id])
    @sub_task_type.destroy

    respond_to do |format|
      format.html { redirect_to task_type_sub_task_types_url(@task_type) }
      format.json { head :no_content }
    end
  end
end
