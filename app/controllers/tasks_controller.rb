class TasksController < ActionController::API
  include Authentication
  before_action :authorize_request
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks 
  def index
    tasks = Task.paginate(page: params[:page], per_page: 5)
    render json: tasks, each_serializer: TaskSerializer, status: :ok
  end

  # GET /tasks/1 
  def show
    render json: @task, serializer: TaskSerializer, status: :ok
  end

  # POST /tasks
  def create
    task = Task.new(task_params.merge(user_id: @current_user.id))
    if task.save
      render json: task,serializer: TaskSerializer, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1 
  def update
    if @task.update(task_params)
      render json: @task, serializer: TaskSerializer, status: :ok
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1 
  def destroy
    @task.destroy!
    render json: { message: "Task was successfully destroyed." }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Task not found' }, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :description, :due_date, :status)
    end
end
