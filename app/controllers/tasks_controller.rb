class TasksController < ApplicationController
  before_action :authorize_request
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks 
  def index
    tasks = Task.all
    render json: tasks, status: :ok
  end

  # GET /tasks/1 
  def show
    render json: @task, status: :ok
  end

  # POST /tasks
  def create
    task = Task.new(task_params)
    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1 
  def update
    if @task.update(task_params)
      render json: @task, status: :ok
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1 
  def destroy
    @task.destroy!
    render json: { message: "Task was successfully destroyed." }, status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Task not found' }, status: :not_found
     end
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :due_date, :status)
    end
end
