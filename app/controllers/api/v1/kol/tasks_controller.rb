class Api::V1::Kol::TasksController < Api::V1::Kol::BaseController
  before_action :prepare_task, only: %i[update destroy]

  def index
    @tasks = policy_scope([:kol, Task])
    render json: TaskSerializer.new(@tasks), status: 200
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      render json: TaskSerializer.new(@task), status: 201
    else
      render json: { errors: @task.errors.full_messages }, status: 422
    end
  end

  def update
    authorize @task, policy_class: Kol::TaskPolicy
    if @task.update(task_params)
      render json: TaskSerializer.new(@task), status: 200
    else
      render json: { errors: @task.errors.full_messages }, status: 422
    end
  end

  def destroy
    authorize @task, policy_class: Kol::TaskPolicy
    if @task.destroy
      render json: { message: I18n.t('task.success.deleted') }, status: 200
    else
      render json: { errors: @task.errors.full_messages }, status: 422
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :start_time, :end_time, :status, :description, :kol_profile_id)
  end

  def prepare_task
    @task = Task.find_by(id: params[:id])
  end
end
